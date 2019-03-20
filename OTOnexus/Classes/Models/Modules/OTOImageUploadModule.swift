//
//  OTOImageUploadModule.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation
import AWSS3

extension AWSRegionType {
    
    static func regionTypeForString(regionString: String) -> AWSRegionType {
        switch regionString {
        case "us-east-1": return .USEast1
        case "us-west-1": return .USWest1
        case "us-west-2": return .USWest2
        case "eu-west-1": return .EUWest1
        case "eu-central-1": return .EUCentral1
        case "ap-northeast-1": return .APNortheast1
        case "ap-northeast-2": return .APNortheast2
        case "ap-southeast-1": return .APSoutheast1
        case "ap-southeast-2": return .APSoutheast2
        case "sa-east-1": return .SAEast1
        case "cn-north-1": return .CNNorth1
        case "us-gov-west-1": return .USGovWest1
        default: return .Unknown
        }
    }
}

/**
 OTOImageUploadModule is a module that allows a user to upload photos to the *Soom platform*.
*/
public class OTOImageUploadModule : OTOModule {
    /**
     ImageCompression specifies how much to compress images. The more images are compressed the less time image uploads will take.
     */
    public enum ImageCompression: Float {
        case originalQuality = 1.0
        case highQuality = 0.8
        case mediumQuality = 0.5
        case maxCompression = 0.1
        
        func imageCompressionValue() -> CGFloat {
            return CGFloat(self.rawValue)
        }
    }
    private var getUploadFormAction: OTOGetUploadFormAction?
    private var imageUploadedAction: OTOImageUploadedAction?
    private var complete: ((UIImage?, OTOError?) -> Void)?
    private var image: UIImage?
    private var imageCompression = ImageCompression.highQuality
    
    /// Property that could be used to prompt the user to "uplaod a photo"
    public var promptText = ""
    /// Property that couple be used to notify user of "upload completion"
    public var thanksText = ""
    /// Function to upload image to Soom platform
    public func upload(image:UIImage, imageCompression:ImageCompression = .highQuality, complete:@escaping (UIImage?, OTOError?) -> Void) {
        self.imageCompression = imageCompression
        self.complete = complete
        self.image = image
        getUploadForm()
    }
    
    func getUploadForm() {
        getUploadFormAction?.perform { [weak self]  (getUploadFormResponse, error) in
            guard let strongSelf = self else { return }
            if let uploadFormResponse = getUploadFormResponse {
                strongSelf.uploadToAws(uploadFormActionResponse: uploadFormResponse)
            } else {
                strongSelf.complete?(nil, error)
            }
        }
    }
    
    func uploadToAws(uploadFormActionResponse:OTOGetUploadFormActionResponse) {
        guard let url = saveImageToTempDirectory() else { return }
        let credentials = AWSStaticCredentialsProvider(accessKey: uploadFormActionResponse.accessKeyId,
                                                       secretKey: uploadFormActionResponse.secretAccessKey)
        let bucketRegion =  AWSRegionType.regionTypeForString(regionString:uploadFormActionResponse.bucketRegion)
        let configuration = AWSServiceConfiguration(region: bucketRegion,
                                                    credentialsProvider: credentials)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.body = url
        uploadRequest.key = uploadFormActionResponse.key
        uploadRequest.bucket = uploadFormActionResponse.bucketName
        uploadRequest.contentType = "image/jpeg"
        uploadRequest.acl = .publicRead
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { [weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil }
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
                strongSelf.complete?(nil, OTOError.connectivityError(error, nil))
            } else if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                if let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!) {
                    strongSelf.imageUploadedTo(s3Url: publicURL.absoluteString)
                }
            }
            return nil
        }
    }
    
    func imageUploadedTo(s3Url:String) {
        imageUploadedAction?.s3Url = s3Url
        print("image uploaded successfully to \(s3Url)")
        imageUploadedAction?.perform { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.complete?(strongSelf.image, nil)
            } else {
                strongSelf.complete?(nil, error)
            }
        }
    }
    
    func saveImageToTempDirectory() -> URL? {
        guard let image = self.image,
            let data = UIImageJPEGRepresentation(image, imageCompression.imageCompressionValue()) else { return nil }
        // consider scaling image down if too large
        
        let tempUrl = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileUrl = tempUrl.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        if ((try? data.write(to: fileUrl)) != nil) {
            return fileUrl
        } else {
            return nil
        }
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        let config = responseData.responseDataValue(forKey: "config")
        
        self.promptText = config.stringValue(forKey: "prompt_text")
        self.thanksText = config.stringValue(forKey: "thanks_text")
        
        self.getUploadFormAction = self.action(forName: "get_upload_form", responseData: responseData)
        self.imageUploadedAction = self.action(forName: "submit_upload_url", responseData: responseData)
    }
}

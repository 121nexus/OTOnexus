//
//  OTOImageUploadModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/27/17.
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
 OTOImageUploadModule is a module that allows a user to upload photos to the *121nexus platform*.
*/
public class OTOImageUploadModule : OTOModule {
    private var getUploadFormAction: OTOGetUploadFormAction?
    private var imageUploadedAction: OTOImageUploadedAction?
    private var complete: ((UIImage?, OTOError?) -> Void)?
    private var image: UIImage?
    
    /// Property that could be used to prompt the user to "uplaod a photo"
    public var promptText = ""
    /// Property that couple be used to notify user of "upload completion"
    public var thanksText = ""
    /// Function to upload image to 121nexus platform
    public func upload(image:UIImage, complete:@escaping (UIImage?, OTOError?) -> Void) {
        self.complete = complete
        self.image = resizeImage(image: image)
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
                strongSelf.complete?(nil, OTOError.errorFromServer(error))
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
            let data = UIImageJPEGRepresentation(image, 1.0) else { return nil }
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
    
    private func resizeImage(image:UIImage) -> UIImage {
        let maxDimension = CGFloat(1024)
        var newSize:CGSize?
        if image.size.width >= image.size.height && image.size.width > maxDimension {
            let ratio = maxDimension / image.size.width
            let scaledHeight = ratio * image.size.height
            newSize = CGSize(width: maxDimension, height: scaledHeight)
        } else if image.size.height > image.size.width && image.size.height > maxDimension {
            let ratio = maxDimension / image.size.height
            let scaledWidth = ratio * image.size.width
            newSize = CGSize(width: scaledWidth, height: maxDimension)
        }
        if let newSize = newSize {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            if let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return newImage
            }
        }
        
        return image
    }
}

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

public class OTOImageUploadModule : OTOModule {
    private var getUploadFormAction: OTOGetUploadFormAction?
    private var imageUploadedAction: OTOImageUploadedAction?
    private var complete: ((Bool) -> Void)?
    private var image: UIImage?
    
    required public init() {
        self.getUploadFormAction = OTOGetUploadFormAction()
        self.imageUploadedAction = OTOImageUploadedAction()
    }
    
    public func upload(image:UIImage, complete:@escaping (Bool) -> Void) {
        self.complete = complete
        self.image = image
        getUploadForm()
    }
    
    func getUploadForm() {
        getUploadFormAction?.perform { (getUploadFormResponse, error) in
            if let uploadFormResponse = getUploadFormResponse {
                self.uploadToAws(uploadFormActionResponse: uploadFormResponse)
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
        transferManager.upload(uploadRequest).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
                self.complete?(false)
            } else if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                if let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!) {
                    self.imageUploadedTo(s3Url: publicURL.absoluteString)
                }
            }
            return nil
        }
    }
    
    func imageUploadedTo(s3Url:String) {
        imageUploadedAction?.s3Url = s3Url
        print("image uploaded successfully to \(s3Url)")
        imageUploadedAction?.perform { (response, error) in
            self.complete?(error == nil)
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
        
        if let getUploadFormAction = responseData.responseData(forKey: "actions")?.responseData(forKey: "get_upload_form") {
            self.getUploadFormAction = OTOGetUploadFormAction.decode(getUploadFormAction)
        }
    }
}

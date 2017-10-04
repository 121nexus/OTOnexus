//
//  OTOGetUploadFormAction.swift
//  AWSCore
//
//  Created by Nicholas Schlueter on 9/27/17.
//

import Foundation

class OTOGetUploadFormAction : OTOAction<OTOGetUploadFormActionResponse> {
    override func process(responseObject: ResponseObject) -> OTOGetUploadFormActionResponse? {
        guard let uploadForm = responseObject.data?.responseData(forKey: "aws_upload_form") else { return nil }
        return OTOGetUploadFormActionResponse.decode(uploadForm)
    }
}

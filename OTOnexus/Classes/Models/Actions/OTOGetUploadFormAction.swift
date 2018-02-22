//
//  OTOGetUploadFormAction.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

class OTOGetUploadFormAction : OTOAction<OTOGetUploadFormActionResponse> {
    override func process(responseObject: ResponseObject) -> OTOGetUploadFormActionResponse? {
        guard let uploadForm = responseObject.data?.responseData(forKey: "aws_upload_form") else { return nil }
        return OTOGetUploadFormActionResponse.decode(uploadForm)
    }
}

//
//  OTOLookupAction.swift
//  AWSCore
//
//  Created by Nicholas Schlueter on 10/6/17.
//

import Foundation

class OTOLookupAction : OTOAction<OTOLookupResponse> {
    override func process(responseObject: ResponseObject) -> OTOLookupResponse? {
        if let message = responseObject.dataValue().string(forKey: "message") {
            let failure = OTOLookupFailureResponse()
            failure.message = message
            return failure
        } else {
            return OTOLookupSuccessResponse.decode(responseObject.dataValue())
        }
    }
}


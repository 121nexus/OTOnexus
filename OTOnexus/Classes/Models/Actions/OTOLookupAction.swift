//
//  OTOLookupAction.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
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


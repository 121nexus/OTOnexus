//
//  OTOLookupAction.swift
//  AWSCore
//
//  Created by Nicholas Schlueter on 10/6/17.
//

import Foundation

class OTOLookupAction : OTOAction<OTOLookupResponse> {
    override func process(responseObject: ResponseObject) -> OTOLookupResponse? {
        return OTOLookupResponse.decode(responseObject.dataValue())
    }
}


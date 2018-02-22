//
//  PutWebServiceOperation.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

class PutWebServiceOperation : PostWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .PUT
    }
}

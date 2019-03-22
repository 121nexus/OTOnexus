//
//  PutWebServiceOperation.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class PutWebServiceOperation : PostWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .PUT
    }
}

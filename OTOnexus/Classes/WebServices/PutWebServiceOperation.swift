//
//  PutWebServiceOperation.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/18/17.
//

import Foundation

class PutWebServiceOperation : PostWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .PUT
    }
}

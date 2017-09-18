//
//  DeleteWebServiceOperation.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/18/17.
//

import Foundation

class DeleteWebServiceOperation : GetWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .DELETE
    }
}

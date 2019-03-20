//
//  DeleteWebServiceOperation.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class DeleteWebServiceOperation : GetWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .DELETE
    }
}

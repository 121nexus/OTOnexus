//
//  HeadWebServiceOperation.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/18/17.
//

import Foundation

class HeadWebServiceOperation : GetWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .HEAD
    }
}

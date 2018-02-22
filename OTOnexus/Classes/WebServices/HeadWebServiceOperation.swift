//
//  HeadWebServiceOperation.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

class HeadWebServiceOperation : GetWebServiceOperation {
    override var method:WebServiceOperation.HttpMethod {
        return .HEAD
    }
}

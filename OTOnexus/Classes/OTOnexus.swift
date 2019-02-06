//
//  OTOnexus.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

/// SDK wide delegate for providing global feedback of events
public protocol OTOnexusLocationDelegate: class {
    func userLocationAccessChanged(denied:Bool)
}

public class OTOnexus {
    static let shared = OTOnexus()
    var delegate:OTOnexusLocationDelegate?
    static var userLocationAccessDenied:Bool {
        return OTOLocationHelper.shared.userDeniedLocation
    }
    
    /// Sets the api key in order to connect ot the *121nexus platform*
    public static func configure(withApiKey apiKey:String, withApiUrl apiUrl:String? = nil, locationDelegate:OTOnexusLocationDelegate?) {
        WebServiceManager.shared.configureWithApiKey(apiKey: apiKey)
        if let apiUrl = apiUrl {
            WebServiceManager.shared.setApiUrl(apiUrl: apiUrl)
        }
        shared.delegate = locationDelegate
        OTOLocationHelper.shared.start()
    }
    
    func userLocationAccessChanged(denied:Bool) {
        delegate?.userLocationAccessChanged(denied: denied)
    }
}

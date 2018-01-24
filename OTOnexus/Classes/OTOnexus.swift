//
//  OTOnexus.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/15/17.
//
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
    public static func configure(withApiKey apiKey:String, locationDelegate:OTOnexusLocationDelegate?) {
        WebServiceManager.shared.configureWithApiKey(apiKey: apiKey)
        shared.delegate = locationDelegate
        OTOLocationHelper.shared.start()
    }
    
    func userLocationAccessChanged(denied:Bool) {
        delegate?.userLocationAccessChanged(denied: denied)
    }
}

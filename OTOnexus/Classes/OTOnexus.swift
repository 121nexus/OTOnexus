//
//  OTOnexus.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/15/17.
//
//

import Foundation

public class OTOnexus {
    static let shared = OTOnexus()
    /// Sets the api key in order to connect ot the *121nexus platform*
    public static func configure(withApiKey apiKey:String) {
        WebServiceManager.shared.configureWithApiKey(apiKey: apiKey)
    }
}

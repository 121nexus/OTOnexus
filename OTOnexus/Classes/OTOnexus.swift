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
    
    public static func configure(withApiKey apiKey:String) {
        WebServiceManager.shared.configureWithApiKey(apiKey: apiKey)
    }
}

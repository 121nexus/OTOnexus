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
    var apiKey = ""
    
    public static func configure(withApiKey apiKey:String) {
        self.shared.apiKey = apiKey
    }
}

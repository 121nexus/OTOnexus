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
    var apiKey = "" {
        didSet {
            WebServiceManager.shared.urlSession.configuration.httpAdditionalHeaders?["api-key"] = apiKey
        }
    }
    
    public static func configure(withApiKey apiKey:String) {
        self.shared.apiKey = apiKey
    }
    
    public static func testApi() {
        WebServiceManager.shared.get(endpoint: "search", params: ["q":"foo"]) { (response) in
            print(response)
        }
    }
}

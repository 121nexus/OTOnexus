//
//  Session.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

final public class Session {
    public var id = ""
    public var productUrl = ""
    
    public static func startSession(withExperience experience:Experience,
                             product:Product? = nil,
                             complete: @escaping (Session) -> Void) {
        let endpoint = "experiences/\(experience.id)/sessions"
        var body:[String: Any] = [:]
        if let product = product {
            body["product_url"] = product.url
        }
        WebServiceManager.shared.post(endpoint: endpoint,
                                      body: body,
                                      success: { (responseObject) in
                                        if let responseObject = responseObject {
                                            complete(decode(responseObject))
                                        }
        },
                                      failure: { (error) in
            
        })
    }
}

extension Session : Decodable {
    func decode(_ responseObject: ResponseObject) {
        self.id = responseObject.string(forKey: "id")
        self.productUrl = responseObject.string(forKey: "product_url")
    }
}

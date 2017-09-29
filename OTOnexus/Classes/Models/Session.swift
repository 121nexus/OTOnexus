//
//  Session.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

public class Session {
    public var id = ""
    public var productUrl = ""
    public var page = [OTOModule]()
    
    public required init() {
    }
    
    public static func startSession(withExperience experience:Experience,
                             product:Product? = nil,
                             complete: @escaping (Session) -> Void) {
        let endpoint = "experiences/\(experience.id)/sessions"
        var body:[String: Any] = [:]
        if let product = product {
            body["product_url"] = product.url
        }
        
        WebServiceManager.shared.post(endpoint: endpoint,
                                      body: body) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            complete(self.decode(responseObject.data))
                                        }
        }
    }
}

extension Session : Decodable {
    func decode(_ responseData:ResponseData) {
        self.id = responseData.stringValue(forKey: "id")
        self.productUrl = responseData.stringValue(forKey: "product_url")
        self.page = OTOModule.array(responseData.arrayValue(forKey: "page"))
    }
}

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
    public var product:Product?
    
    public required init() {
    }
    
    public static func startSession(withExperience experience:Experience,
                             product:Product? = nil,
                             barcode:String? = nil,
                             complete: @escaping (Session) -> Void) {
        self.startSession(withExperienceId: experience.id, product:product, barcode:barcode, complete: complete)
    }
    
    public static func startSession(withExperienceId experienceId:Int,
                                    product:Product? = nil,
                                    barcode:String? = nil,
                                    complete: @escaping (Session) -> Void) {
        let endpoint = "experiences/\(experienceId)/sessions"
        var body:[String: Any] = [:]
        if let product = product {
            body["product_url"] = product.url
            if let barcodeData = product.barcodeData {
                body["raw_scan"] = barcodeData
            }
        } else if let barcode = barcode {
            body["raw_scan"] = barcode
        }
        
        WebServiceManager.shared.post(endpoint: endpoint,
                                      body: body) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            let session = self.decode(responseObject.dataValue())
                                            session.product = product
                                            complete(session)
                                        }
        }
    }
}

extension Session : Decodable {
    func decode(_ responseData:ResponseData) {
        self.id = responseData.stringValue(forKey: "id")
        self.productUrl = responseData.stringValue(forKey: "product_url")
        self.page = OTOModule.array(responseData.arrayValue(forKey: "page"))
        self.page.forEach { (module) in
            module.session = self
        }
    }
}

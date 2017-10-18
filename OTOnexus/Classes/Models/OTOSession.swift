//
//  OTOSession.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

public class OTOSession {
    public var id = ""
    public var productUrl = ""
    public var page = [OTOModule]()
    public var product:OTOProduct?
    public var barcode:String?
    
    public required init() {
    }
    
    public static func startSession(withExperience experience:OTOExperience,
                             product:OTOProduct? = nil,
                             barcode:String? = nil,
                             complete: @escaping (OTOSession) -> Void) {
        self.startSession(withExperienceId: experience.id, product:product, barcode:barcode, complete: complete)
    }
    
    public static func startSession(withExperienceId experienceId:Int,
                                    product:OTOProduct? = nil,
                                    barcode:String? = nil,
                                    complete: @escaping (OTOSession) -> Void) {
        let endpoint = "experiences/\(experienceId)/sessions"
        var body:[String: Any] = [:]
        if let product = product {
            body["product_url"] = product.url
            if let barcodeData = product.barcodeData {
                body["barcode_data"] = barcodeData
            }
        } else if let barcode = barcode {
            body["barcode_data"] = barcode
        }
        
        WebServiceManager.shared.post(endpoint: endpoint,
                                      body: body) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            let session = self.decode(responseObject.dataValue())
                                            session.barcode = body["barcode_data"] as? String
                                            session.product = product
                                            complete(session)
                                        }
        }
    }
}

extension OTOSession : Decodable {
    func decode(_ responseData:ResponseData) {
        self.id = responseData.stringValue(forKey: "id")
        self.productUrl = responseData.stringValue(forKey: "product_url")
        self.page = OTOModule.array(responseData.arrayValue(forKey: "page"))
        self.page.forEach { (module) in
            module.session = self
        }
    }
}

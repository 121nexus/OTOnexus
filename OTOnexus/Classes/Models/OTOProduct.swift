//
//  OTOProduct.swift
//  Pods
//
//  Copyright © 2017 121nexus. All rights reserved.
//

import Foundation
/**
OTOProduct is a class that represents a physical product on the *121nexus platform*. Products can be searched by the barcode data or by unique urls found on the system.
*/
public class OTOProduct {
    /**
    Enum for product lookup error
    - Product not found on platform
    - Server error
    */
    public enum ProductError : Error {
        /// Product not found on platform
        case productNotFound
        /// Server error returned during product search
        case otoError(OTOError)
    }
    public typealias ProductCompleteBlock = (OTOProduct?, ProductError?) -> Void
    /// The associated barcode data and type
    public var barcode:OTOBarcode?
    /// A product url
    public var url = ""
    /// Dictionary of attributes of a product
    public var attributes = [String:Any]()
    var defaultExperienceId = -1
    /// An array of expriences for a product
    public var experiences = [OTOExperience]()
    /// Default experience for a product
    public var defaultExperience:OTOExperience? {
        return experience(forId: defaultExperienceId)
    }
    
    
    required public init() {
    }
    
    /**
     Search for product with barcodeData
     */
    public static func search(barcode:OTOBarcode,
                              complete:@escaping ProductCompleteBlock) {
        self.search(withParams: ["barcode_data": barcode.data],
                    complete: { (product, error) in
                        if let product = product {
                            product.barcode = barcode
                            complete(product, nil)
                        } else {
                            complete(product, error)
                        }
        })
    }
 
    /**
    Search for product with productUrl
    */
       public static func search(productUrl:String,
                              complete:@escaping ProductCompleteBlock) {
        self.search(withParams: ["product_url": productUrl], complete: complete)
    }
    
       static func search(withParams params:[String:String],
                       complete:@escaping ProductCompleteBlock) {
        WebServiceManager.shared.get(endpoint: "products/search",
                                     params: params) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            if responseObject.statusCode == 204 {
                                                complete(nil, ProductError.productNotFound)
                                            } else if responseObject.isSuccessful {
                                                let product = self.decode(responseObject.dataValue())
                                                complete(product, nil)
                                            }
                                        } else if let error = error {
                                            complete(nil, .otoError(error))
                                        }
        }
    }
    /**
     Search for product by experience id
    */
    public func experience(forId experienceId:Int) -> OTOExperience? {
        return experiences.first { (experience) -> Bool in
            return experience.id == experienceId
        }
    }
}

extension OTOProduct : Decodable {
    func decode(_ responseData:ResponseData) {
        self.url = responseData.stringValue(forKey: "url")
        self.experiences = OTOExperience.array(responseData.arrayValue(forKey: "experiences"))
        self.defaultExperienceId = responseData.intValue(forKey: "default_experience_id")
        self.attributes = responseData.dictionaryValue(forKey: "attributes")
    }
}



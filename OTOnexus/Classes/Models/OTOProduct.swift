//
//  OTOProduct.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
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
        case serverError(Error?)
    }
    public typealias ProductSuccessBlock = (OTOProduct) -> Void
    public typealias ProductFailureBlock = (ProductError) -> Void
    /// A barcode's raw data string
    public var barcodeData:String?
    /// Auto captured image during scanning
    public var capturedImage:UIImage?
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
    public static func search(barcodeData:String,
                              success:@escaping ProductSuccessBlock,
                              failure: @escaping ProductFailureBlock) {
        self.search(withParams: ["barcode_data": barcodeData],
                    success: { (product) in
                        product.barcodeData = barcodeData
                        success(product)
        }, failure: failure)
    }
 
    /**
    Search for product with productUrl
    */
       public static func search(productUrl:String,
                              success:@escaping (OTOProduct) -> Void,
                              failure: @escaping ProductFailureBlock) {
        self.search(withParams: ["product_url": productUrl], success: success, failure: failure)
    }
    
       static func search(withParams params:[String:String],
                       success:@escaping ProductSuccessBlock,
                       failure: @escaping ProductFailureBlock) {
        WebServiceManager.shared.get(endpoint: "products/search",
                                     params: params) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            if responseObject.statusCode == 204 {
                                                failure(ProductError.productNotFound)
                                            } else if responseObject.isSuccessful {
                                                let product = self.decode(responseObject.dataValue())
                                                success(product)
                                            }
                                        } else {
                                            failure(ProductError.serverError(nil))
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



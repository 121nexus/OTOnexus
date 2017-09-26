//
//  Product.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

final public class Product {
    public var barcodeData:String?
    public var url = ""
    var defaultExperienceId = -1
    public var experiences = [Experience]()
    public var defaultExperience:Experience? {
        let foundExperience = experiences.first { (experience) -> Bool in
            return experience.id == defaultExperienceId
        }
        return foundExperience
    }
    
    required public init() {
    }
    
    public static func search(barcodeData:String, success:@escaping (Product) -> Void) {
        WebServiceManager.shared.get(endpoint: "products/search",
                                     params: ["barcode_data": barcodeData]) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            if responseObject.isSuccessful {
                                                let product = self.decode(responseObject.data)
                                                product.barcodeData = barcodeData
                                                success(product)
                                            }
                                        }
        }
    }
}

extension Product : Decodable {
    func decode(_ responseData:ResponseData) {
        self.url = responseData.stringValue(forKey: "url")
        self.experiences = Experience.array(responseData.arrayValue(forKey: "experiences"))
        self.defaultExperienceId = responseData.intValue(forKey: "default_experience")
    }
}



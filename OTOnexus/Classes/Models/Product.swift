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
                                     params: ["barcode_data": barcodeData],
                                     success: { (response) in
                                        if let response = response {
                                            let product = self.decode(response.data)
                                            product.barcodeData = barcodeData
                                            success(product)
                                        }
        },
                                     failure: { (error) in
                                        print(error)
        })
    }
}

extension Product : Decodable {
    func decode(_ responseData:ResponseData) {
        self.url = responseData.string(forKey: "url")
        self.experiences = Experience.array(responseData.array(forKey: "experiences"))
        self.defaultExperienceId = responseData.int(forKey: "default_experience")
    }
}



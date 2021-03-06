//
//  OTOSession.swift
//  Pods
//
//  Copyright © 2017 Soom. All rights reserved.
//

import Foundation

public protocol OTOSessionDelegate : class {
    /// The function that fires when the page transitions to a new set of modules
    func sessionDidUpdatePage()
}

/**
OTOSession is a class that allows you to start a session to track user interactions with an experience.
*/
public class OTOSession {
    /// The ID of the session
    public var id = ""
    /// Product associated with current session
    public var productUrl = ""
    /// The active page of the session, includes a list of modules associated with that page
    public var page = [OTOModule]()
    /// A product on the 121 platform
    public var product:OTOProduct?
    /// A scanned barcode
    public var barcode:OTOBarcode?
    /// A delegate that notifies when the session transitions to the next page
    public weak var delegate:OTOSessionDelegate?
    
    /// :nodoc:
    public required init() {
    }
    /// Function that starts a new session
    public static func startSession(withExperience experience:OTOExperience,
                             product:OTOProduct? = nil,
                             barcode:OTOBarcode? = nil,
                             complete: @escaping (OTOSession?, OTOError?) -> Void) {
        self.startSession(withExperienceId: experience.id, product:product, barcode:barcode, complete: complete)
    }
    
    /// Function that starts a new session with a *experienceID*
    public static func startSession(withExperienceId experienceId:Int,
                                    product:OTOProduct? = nil,
                                    barcode:OTOBarcode? = nil,
                                    complete: @escaping (OTOSession?, OTOError?) -> Void) {
        let endpoint = "experiences/\(experienceId)/sessions"
        var body:[String: Any] = [:]
        if let product = product {
            body["product_url"] = product.url
            if let barcodeData = product.barcode?.data {
                body["barcode_data"] = barcodeData
            }
        } else if let barcode = barcode {
            body["barcode_data"] = barcode.data
        }
        
        if let currentLocation = OTOLocationHelper.shared.currentLocation {
            body["location_data"] = ["latitude":currentLocation.coordinate.latitude,
                                     "longitude":currentLocation.coordinate.longitude]
        }
        
        WebServiceManager.shared.post(endpoint: endpoint,
                                      body: body) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            let session = self.decode(responseObject.dataValue())
                                            session.barcode = barcode
                                            session.product = product
                                            complete(session, nil)
                                        } else {
                                            complete(nil, error)
                                        }
        }
    }
    
    public func preloadModuleData(complete: @escaping (Bool, [OTOError]) -> Void) {
        var errors = [OTOError]()
        let dispatchGroup = DispatchGroup()
        for module in self.page {
            if let gudidModule = module as? OTOGudidModule  {
                dispatchGroup.enter()
                gudidModule.lookup(complete: { (_, error) in
                    if let error = error {
                        errors.append(error)
                    }
                    dispatchGroup.leave()
                })
            } else if let safetyCheckModule = module as? OTOSafetyCheckModule {
                dispatchGroup.enter()
                safetyCheckModule.checkSafety(complete: { (_, error) in
                    if let error = error {
                        errors.append(error)
                    }
                    dispatchGroup.leave()
                })
            } else if let gs1Module = module as? OTOGs1ValidationModule {
                dispatchGroup.enter()
                gs1Module.validateBarcode(complete: { (_, error) in
                    if let error = error {
                        errors.append(error)
                    }
                    dispatchGroup.leave()
                })
            } else if let customValidationModule = module as? OTOCustomValidationModule {
                dispatchGroup.enter()
                customValidationModule.validateBarcode(complete: { (_, error) in
                    if let error = error {
                        errors.append(error)
                    }
                    dispatchGroup.leave()
                })
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            complete(errors.count == 0, errors)
        }
    }
    
    func getLatestSessionData() {
        let endpoint = "sessions/\(self.id)"
        WebServiceManager.shared.get(endpoint: endpoint,
                                     params: [:]) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            self.decode(responseObject.dataValue())
                                            self.delegate?.sessionDidUpdatePage()
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

//
//  OTOLookupSuccessResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/11/17.
//

import Foundation

public class OTOLookupSuccessResponse: OTOLookupResponse {
    public var fullResponse:[String:Any]?
    public var companyName = ""
    public var deviceDescription = ""
    public var brandName = ""
    public var email = ""
    public var phone = ""
    public var phoneExtension:String?
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.fullResponse = responseData.storage
        self.deviceDescription = responseData.stringValue(forKey: "deviceDescription")
        self.companyName = responseData.stringValue(forKey: "companyName")
        self.brandName = responseData.stringValue(forKey: "brandName")
        
        let contact = responseData.responseDataValue(forKey: "contacts").responseDataValue(forKey: "customerContact")
        
        self.email = contact.stringValue(forKey: "email")
        self.phone = contact.stringValue(forKey: "phone")
        self.phoneExtension = contact.string(forKey: "phoneExtension")
    }
}

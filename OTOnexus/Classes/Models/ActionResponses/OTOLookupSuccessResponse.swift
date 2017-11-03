//
//  OTOLookupSuccessResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/11/17.
//

import Foundation

public class OTOLookupSuccessResponse: OTOLookupResponse {
    /// Complete FDA GUDID data response from AccessGUDID database. Use this if you would like to pull out specific data from the response.
    public var fullResponse:[String:Any]?
    
    /**
    A set of the most commonly used data element variables that get returned from the FDA AcessGUDID database
     - companyName: Company who manufactured the medical device
     - deviceDescription: Short description of the medical device
     - brandName: Brand or division that manufactures device
     - lot: Batch/Lot number associated with device
     - expirationDate: Device date of expiration 
     - email: email of manufacturer on file
     - phone: phone number of manufacturer
     - phoneExtenstion: phone extension for the manufacturer
    */
    public var companyName = ""
    public var deviceDescription = ""
    public var brandName = ""
    public var lot:String?
    public var expirationDate:Date?
    public var email = ""
    public var phone = ""
    public var phoneExtension:String?
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.fullResponse = responseData.storage
        self.deviceDescription = responseData.stringValue(forKey: "deviceDescription")
        self.companyName = responseData.stringValue(forKey: "companyName")
        self.brandName = responseData.stringValue(forKey: "brandName")
        self.lot = responseData.string(forKey: "udi_lot_number")
        if let udiExpirationDate = responseData.string(forKey: "udi_expiration_date") {
            self.expirationDate = OTODateHelper.shared.yearMonthDayParser.date(from: udiExpirationDate)
        }
        
        let contact = responseData.responseDataValue(forKey: "contacts").responseDataValue(forKey: "customerContact")
        
        self.email = contact.stringValue(forKey: "email")
        self.phone = contact.stringValue(forKey: "phone")
        self.phoneExtension = contact.string(forKey: "phoneExtension")
        
    }
}

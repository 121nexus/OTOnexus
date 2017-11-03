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
    /// Company who manufactured the medical device
    public var companyName = ""
    /// Short description of the medical device
    public var deviceDescription = ""
    ///Brand or corporate division that manufactures device
    public var brandName = ""
    /// Batch/Lot number associated with device
    public var lot:String?
    /// Device date of expiration
    public var expirationDate:Date?
    /// Contact email at manufacturer
    public var email = ""
    /// Phone number of manufacturer
    public var phone = ""
    /// Phone extention of manufacturer
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

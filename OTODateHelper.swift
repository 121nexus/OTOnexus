//
//  OTODateHelper.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/11/17.
//

import Foundation

class OTODateHelper {
    static let shared = OTODateHelper()
    
    var yearMonthDayParser:DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
}

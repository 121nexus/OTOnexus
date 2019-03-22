//
//  OTODateHelper.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
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

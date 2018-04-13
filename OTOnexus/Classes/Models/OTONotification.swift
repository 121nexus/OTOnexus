//
//  OTONotification.swift
//  OTOnexus
//
//  Created by Andrew McKnight on 2/27/18.
//

import Foundation

/**
 OTONotification provides keys you can observe in the `NotificationCenter` for UIevents
 */
public enum OTONotification: String {
    case resetResults
    case flashEnabled
    case flashDisabled
    case singleBarcode
    case stackedBarcode

    /// :nodoc:
    public init?(name: Notification.Name) {
        if name.rawValue == OTONotification.resetResults.rawValue { self = .resetResults }
        else if name.rawValue == OTONotification.flashEnabled.rawValue { self = .flashEnabled }
        else if name.rawValue == OTONotification.flashDisabled.rawValue { self = .flashDisabled }
        else if name.rawValue == OTONotification.singleBarcode.rawValue { self = .singleBarcode }
        else if name.rawValue == OTONotification.stackedBarcode.rawValue { self = .stackedBarcode }
        else { return nil }
    }

    /// :nodoc:
    public func name() -> Notification.Name {
        switch self {
        case .resetResults: return Notification.Name(OTONotification.resetResults.rawValue)
        case .flashEnabled: return Notification.Name(OTONotification.flashEnabled.rawValue)
        case .flashDisabled: return Notification.Name(OTONotification.flashDisabled.rawValue)
        case .singleBarcode: return Notification.Name(OTONotification.singleBarcode.rawValue)
        case .stackedBarcode: return Notification.Name(OTONotification.stackedBarcode.rawValue)
        }
    }
}

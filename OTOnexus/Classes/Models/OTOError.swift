//
//  OTOError.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/10/17.
//

import Foundation

public enum OTOError: Error {
    case errorFromServer(Error)
    case errorWithMessage(String)
    case unauthenticated
}

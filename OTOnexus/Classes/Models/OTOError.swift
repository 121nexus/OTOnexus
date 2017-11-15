//
//  OTOError.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/10/17.
//

import Foundation

public enum OTOError: Error {
    case connectivityError(Error, HTTPURLResponse?)
    case validationErrorWithMessage(String, HTTPURLResponse?)
    case serverErrorWithMessage(String, HTTPURLResponse?)
    case unauthenticated
}

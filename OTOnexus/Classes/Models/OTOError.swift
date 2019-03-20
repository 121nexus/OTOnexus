//
//  OTOError.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

/**
OTOError is the error object that can be returned from most network calls

 USAGE:
 
         switch error {
         case .connectivityError(let error, let httpUrlResponse):
            if let httpUrlResponse = httpUrlResponse {
                print(httpUrlResponse.statusCode)
            }
            print(error)
         case .validationErrorWithMessage(let message, let httpUrlResponse):
            if let httpUrlResponse = httpUrlResponse {
                print(httpUrlResponse.statusCode)
            }
            print(message)
         case .serverErrorWithMessage(let message, let httpUrlResponse):
            if let httpUrlResponse = httpUrlResponse {
                print(httpUrlResponse.statusCode)
            }
            print(message)
         case .unauthenticated:
            print("Please provide valid API Key")
         }
 
*/
public enum OTOError: Error {
    case connectivityError(Error, HTTPURLResponse?)
    case validationErrorWithMessage(String, HTTPURLResponse?)
    case serverErrorWithMessage(String, HTTPURLResponse?)
    case unauthenticated
}

//
//  ErrorManager.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation

class errorManager: NSObject {

}
let ErrorObjectDomain = "NewsAppErrorDomain"

enum WhiteLabelErrorCode {
    case UnknownError
    case JSONParserError
    case GlobalError(code: Int, reason: String)
}

func errorWithCode(code: WhiteLabelErrorCode) -> NSError {
    switch code {
    case .UnknownError:
        return NSError(domain: ErrorObjectDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])
    case .JSONParserError:
        return NSError(domain: ErrorObjectDomain, code: -2, userInfo: [NSLocalizedDescriptionKey: "JSON parser error"])
    case let .GlobalError(code, reason):
        return NSError(domain: ErrorObjectDomain, code: code, userInfo: [NSLocalizedDescriptionKey: reason])
    }
}

//
//  ResponseErrorModel.swift
//  NewsApp
//
//  Created by Mac on 28/08/24.
//

import Foundation

public struct ResponseErrorModel {
    public var message: String
    public var code: Int
    public var status: String
    
    init(code: Int, message: String, status: String) {
        self.code = code
        self.status = status
        switch code {
            case 504:
                self.message = "Request Time Out"
            default:
                self.message = message
        }
    }
}

//
//  APIError.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

struct APIError: Error, Codable {
    let message: String
    let statusCode: Int
    let isSessionTaskError: Bool
    let args: [String]
}

extension APIError {
    static let generalError = APIError(message: "Ooops, something went wrong.".localized, statusCode: 0, isSessionTaskError: false, args: [])
}

//
//  AddPendingRequestResponse.swift
//  LittleSDK
//
//  Created by Boaz James on 08/04/2025.
//

import Foundation

// MARK: - AddPendingRequestResponse
struct AddPendingRequestResponse: Codable {
    let status: String
    let message: String?
    let trxRef: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case trxRef = "TrxRef"
    }
}

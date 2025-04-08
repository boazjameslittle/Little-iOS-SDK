//
//  PendingTransactionResponse.swift
//  LittleSDK
//
//  Created by Boaz James on 08/04/2025.
//

import Foundation

// MARK: - PendingTransactionResponse
struct PendingTransactionResponse: Codable {
    let status, message, trxRef: String?
    let trxDetails: [TransactionDetails]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case trxRef = "TrxRef"
        case trxDetails = "TrxDetails"
    }
}

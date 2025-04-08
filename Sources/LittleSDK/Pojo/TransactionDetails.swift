//
//  TransactionDetails.swift
//  LittleSDK
//
//  Created by Boaz James on 08/04/2025.
//

// MARK: - TransactionDetails
struct TransactionDetails: Codable {
    let id: Int?
    let trxID, status, bankID, notes: String?
    let createdOn, transactionRequest, moduleID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case trxID = "trx_id"
        case status
        case bankID = "bank_id"
        case notes
        case createdOn = "created_on"
        case transactionRequest = "transaction_request"
        case moduleID = "module_id"
    }
}

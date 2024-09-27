//
//  Logger.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation
import Alamofire

final class Logger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️⚡️⚡️⚡️⚡️ Request Started: \(request)
        ⚡️⚡️⚡️⚡️⚡️ Body Data: \(body)
        """
        SDKUtils.printObject(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        SDKUtils.printObject("⚡️⚡️⚡️⚡️⚡️ Response Received: \(response.debugDescription)")
    }
}

//
//  CustomResponseSerializer.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Alamofire
import Foundation

final class ClearTextResponseSerializer<T: Codable>: ResponseSerializer {
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private lazy var successSerializer = DecodableResponseSerializer<T>(decoder: decoder)
    private lazy var errorSerializer = DecodableResponseSerializer<APIError>(decoder: decoder)
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Swift.Result<T, APIError> {
        
        guard error == nil else {
            SDKUtils.printObject("error response", error?.localizedDescription)
            return .failure(APIError(message: "Unknown error", statusCode: error?.asAFError?.responseCode ?? 0, isSessionTaskError: error?.asAFError?.isSessionTaskError ?? false, args: []))
        }
        
        guard let response = response else { return .failure(APIError(message: "Empty response", statusCode: error?.asAFError?.responseCode ?? 0, isSessionTaskError: error?.asAFError?.isSessionTaskError ?? false, args: [])) }
        
        do {
            if response.statusCode < 200 || response.statusCode >= 300 {
                let result = try errorSerializer.serialize(request: request, response: response, data: data, error: nil)
                if let data = data {
                    SDKUtils.printObject("raw response", data)
                }
                return .failure(result)
            } else {
                var customData: Data? = nil
                if let data = data {
                    let dataStr = String(decoding: data, as: UTF8.self)
                    customData = dataStr.replacingOccurrences(of: "{},", with: "").data(using: .utf8)
                    SDKUtils.printObject("clearTextReponse", dataStr)
                }
                let result = try successSerializer.serialize(request: request, response: response, data: customData, error: nil)
                return .success(result)
            }
        } catch(let err) {
            SDKUtils.printObject("Serialization Error", err.localizedDescription)
            let error = APIError(message: "Could not serialize body", statusCode: err.asAFError?.responseCode ?? 0, isSessionTaskError: err.asAFError?.isSessionTaskError ?? false, args: [])
            return .failure(error)
        }
        
    }
    
}

extension DataRequest {
    @discardableResult func clearTextResponseDecodable<T: Codable>(queue: DispatchQueue = DispatchQueue(label: "NetworkRequest", qos: .background, attributes: .concurrent), of t: T.Type, completionHandler: @escaping (Swift.Result<T, APIError>) -> Void) -> Self {
        return response(queue: .main, responseSerializer: ClearTextResponseSerializer<T>()) { response in
            switch response.result {
            case .success(let result):
                completionHandler(result)
            case .failure(let error):
                completionHandler(.failure(APIError(message: "Other error", statusCode: error.responseCode ?? 0, isSessionTaskError: error.isSessionTaskError, args: [error.localizedDescription])))
            }
        }
    }
}

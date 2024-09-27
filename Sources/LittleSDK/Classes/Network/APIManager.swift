//
//  APIManager.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Alamofire
import Foundation

class APIManager {
    
    // MARK: - Vars & Lets
    private let sessionManager: Session
    
    // MARK: - Vars & Lets
    private static var sharedApiManager: APIManager = {
        let manager: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 120
            
        #if DEBUG
            return Session(configuration: configuration, eventMonitors: [Logger()])
        #else
            return Session(configuration: configuration, eventMonitors: [])
        #endif
        }()
        let apiManager = APIManager(sessionManager: manager)
        
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    func callClearText<T:Codable>(_ decodable: T.Type, type: EndPoint, params: Parameters? = nil, completion: @escaping (Swift.Result<T, APIError>) -> Void )  {
        self.sessionManager.request(
            type.url,
            method: type.httpMethod,
            parameters: params,
            encoding: type.encoding,
            headers: type.headers)
        .validate()
        .clearTextResponseDecodable(of: decodable) { result in
            completion(result)
        }
        
    }
}

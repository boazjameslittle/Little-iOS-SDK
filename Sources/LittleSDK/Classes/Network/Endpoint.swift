//
//  Endpoint.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation
import Alamofire

protocol EndPointProtocol {
    var baseURL: String { get }
    var httpMethod: HTTPMethod { get }
    var url: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    
}

enum EndPoint {
    case main
    case googleMapPlaces
    case googleMapDirections
    case locationDetails
    case getFleetEngineVehicleDetails(_ vehicleId: String)
    case getFleetTripDetails(_ tripId: String)
}

extension EndPoint: EndPointProtocol {
    var path: String {
        switch self {
        case .main:
            return ""
        case .googleMapPlaces:
            return "place/autocomplete/json"
        case .googleMapDirections:
            return "directions/json"
        case .locationDetails:
            return "geocode/json"
        case .getFleetEngineVehicleDetails(let vehicleId):
            return "vehicles/\(vehicleId)"
        case .getFleetTripDetails(let tripId):
            return "trips/\(tripId)"
        }
    }
    
    var baseURL: String {
        switch self {
        case .googleMapDirections, .googleMapPlaces, .locationDetails:
            return SDKConstants.GOOGLE_MAP_BASE_URL
        case .getFleetEngineVehicleDetails, .getFleetTripDetails:
            return SDKAllMethods().DecryptDataKC(DataToSend: SDKConstants.FLEET_ENGINE_BASE_URL) as String
        default:
            return SDKAllMethods().DecryptDataKC(DataToSend: SDKConstants().link()) as String
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .googleMapPlaces, .googleMapDirections, .locationDetails, .getFleetEngineVehicleDetails, .getFleetTripDetails:
            return .get
        default:
            return .post
        }
    }
    
    var url: URL {
        return URL(string: "\(baseURL)\(path)")!
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getFleetEngineVehicleDetails, .getFleetTripDetails:
            let token = JwtUtil.generateFleetEngineToken()
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    
}

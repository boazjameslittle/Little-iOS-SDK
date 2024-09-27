//
//  TripOTP.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

struct TripOTP: Codable {
    let startTripOTP, parkingOTP, tollChargeOTP, endTripOTP: String?
    
    enum CodingKeys: String, CodingKey {
        case startTripOTP = "StartTripOTP"
        case parkingOTP = "ParkingOTP"
        case tollChargeOTP = "TollChargeOTP"
        case endTripOTP = "EndTripOTP"
    }
}

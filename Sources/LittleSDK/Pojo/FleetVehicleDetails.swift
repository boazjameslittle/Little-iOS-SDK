//
//  FleetVehicleDetails.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

// MARK: - FleetVehicleDetails
struct FleetVehicleDetails: Codable {
    let name, vehicleState: String?
    let supportedTripTypes: [String]?
    let lastLocation: FleetVehicleLastLocation?
    let maximumCapacity: Int?
    let attributes: [FleetVehicleAttribute]?
    let vehicleType: FleetVehicleType?
    let currentRouteSegmentVersion, waypointsVersion: String?
}

// MARK: - FleetVehicleAttribute
struct FleetVehicleAttribute: Codable {
    let key, stringValue: String?
}

// MARK: - FleetVehicleLastLocation
struct FleetVehicleLastLocation: Codable {
    let location: FleetVehicleLocation?
    let updateTime: String?
    let altitude: Int?
    let locationSensor, serverTime: String?
    let rawLocation: FleetVehicleLocation?
    let rawLocationTime: String?
    let latlngAccuracy, altitudeAccuracy, rawLocationAccuracy: Double?
    let rawLocationSensor: String?
    let heading: Double?
}

// MARK: - FleetVehicleLocation
struct FleetVehicleLocation: Codable {
    let latitude, longitude: Double?
}

// MARK: - FleetVehicleType
struct FleetVehicleType: Codable {
    let category: String?
}

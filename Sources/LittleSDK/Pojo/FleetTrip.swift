//
//  FleetTrip.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

// MARK: - FleetTrip
struct FleetTrip: Codable {
    let name, vehicleID, tripStatus, tripType: String?
    let pickupPoint: DropoffPoint?
    let pickupTime: String?
    let dropoffPoint: DropoffPoint?
    let dropoffTime: String?
    let route: [LocationPoint]?
    let lastLocation: LastLocation?
    let remainingDistanceMeters: Double?
    let etaToFirstWaypoint: String?
    let remainingWaypoints: [RemainingWaypoint]?
    let currentRouteSegmentVersion, remainingWaypointsVersion: String?
    let actualPickupPoint: ActualPickupPoint?
    let currentRouteSegmentEndPoint: CurrentRouteSegmentEndPoint?
    let lastLocationSnappable: Bool?
    let remainingTimeToFirstWaypoint: String?
    let currentRouteSegmentTraffic: CurrentRouteSegmentTraffic?
    let remainingWaypointsRouteVersion, currentRouteSegmentTrafficVersion, view: String?

    enum CodingKeys: String, CodingKey {
        case name
        case vehicleID = "vehicleId"
        case tripStatus, tripType, pickupPoint, pickupTime, dropoffPoint, dropoffTime, route, lastLocation, remainingDistanceMeters, etaToFirstWaypoint, remainingWaypoints, currentRouteSegmentVersion, remainingWaypointsVersion, actualPickupPoint, currentRouteSegmentEndPoint, lastLocationSnappable, remainingTimeToFirstWaypoint, currentRouteSegmentTraffic, remainingWaypointsRouteVersion, currentRouteSegmentTrafficVersion, view
    }
}

// MARK: - ActualPickupPoint
struct ActualPickupPoint: Codable {
    let point: LocationPoint?
    let timestamp: String?
}

// MARK: - LocationPoint
struct LocationPoint: Codable {
    let latitude, longitude: Double?
}

// MARK: - CurrentRouteSegmentEndPoint
struct CurrentRouteSegmentEndPoint: Codable {
    let location: DropoffPoint?
    let tripID, waypointType: String?

    enum CodingKeys: String, CodingKey {
        case location
        case tripID = "tripId"
        case waypointType
    }
}

// MARK: - DropoffPoint
struct DropoffPoint: Codable {
    let point: LocationPoint?
}

// MARK: - CurrentRouteSegmentTraffic
struct CurrentRouteSegmentTraffic: Codable {
    let speedReadingInterval: [SpeedReadingInterval]?
    let encodedPathToWaypoint: String?
}

// MARK: - SpeedReadingInterval
struct SpeedReadingInterval: Codable {
    let endPolylinePointIndex: Int?
    let speed: String?
    let startPolylinePointIndex: Int?
}

// MARK: - LastLocation
struct LastLocation: Codable {
    let location: LocationPoint?
    let speedKmph: Double?
    let updateTime: String?
    let speed: Double?
    let locationSensor, serverTime: String?
    let latlngAccuracy: Double?
}

// MARK: - RemainingWaypoint
struct RemainingWaypoint: Codable {
    let location: DropoffPoint?
    let tripID, waypointType, encodedPathToWaypoint: String?
    let distanceMeters: Double?
    let eta, duration: String?
    let trafficToWaypoint: CurrentRouteSegmentTraffic?

    enum CodingKeys: String, CodingKey {
        case location
        case tripID = "tripId"
        case waypointType, encodedPathToWaypoint, distanceMeters, eta, duration, trafficToWaypoint
    }
}

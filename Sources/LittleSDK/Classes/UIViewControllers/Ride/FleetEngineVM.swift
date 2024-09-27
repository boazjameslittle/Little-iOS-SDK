//
//  FleetEngineVM.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class FleetEngineVM: BaseVM {
    private let _vehicleDetailsResponse = BehaviorRelay<Resource<FleetVehicleDetails>?>(value:nil)
    var vehicleDetailsResponse: Observable<Resource<FleetVehicleDetails>?> {
        return _vehicleDetailsResponse.asObservable()
    }
    
    private let _fleetTripDetailsResponse = BehaviorRelay<Resource<FleetTrip>?>(value:nil)
    var fleetTripDetailsResponse: Observable<Resource<FleetTrip>?> {
        return _fleetTripDetailsResponse.asObservable()
    }
    
    func getVehicleDetails(vehicleId: String) {
        _vehicleDetailsResponse.accept(.loading)
        
        APIManager.shared().callClearText(FleetVehicleDetails.self, type: EndPoint.getFleetEngineVehicleDetails(vehicleId)) { [weak self] response in
            self?._vehicleDetailsResponse.accept(.data(response))
        }
    }
    
    func geTripDetails(tripId: String) {
        _fleetTripDetailsResponse.accept(.loading)
        
        APIManager.shared().callClearText(FleetTrip.self, type: EndPoint.getFleetTripDetails(tripId)) { [weak self] response in
            self?._fleetTripDetailsResponse.accept(.data(response))
        }
    }
    
}

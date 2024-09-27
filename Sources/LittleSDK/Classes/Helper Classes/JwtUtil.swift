//
//  JwtUtil.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation
import SwiftJWT


class JwtUtil {
    // MARK: - JwtClaim
    struct JwtClaim: Claims {
        let aud: String?
        let iss, sub: String?
        let iat, exp: Double?
        let authorization: JwtAuthorization?
    }

    // MARK: - JwtAuthorization
    struct JwtAuthorization: Claims {
        let vehicleid, tripid: String?
    }
    
    static func generateFleetEngineToken() -> String {
        let am = SDKAllMethods()
        let kid = am.DecryptDataKC(DataToSend: SDKConstants.GOOGLE_KEY_ID) as String
        let providerId = am.DecryptDataKC(DataToSend: SDKConstants.GOOGLE_PROVIDER_ID) as String
        
        SDKUtils.printObject("mykid", kid)
        SDKUtils.printObject("myproviderId", providerId)
        
        let header = Header(typ: "JWT", kid: kid)
        
        let authClaim = JwtAuthorization(vehicleid: "*", tripid: "*")
        
        let claims = JwtClaim(aud: "https://fleetengine.googleapis.com/", iss: "fleet-engine-su@\(providerId).iam.gserviceaccount.com", sub: "fleet-engine-su@\(providerId).iam.gserviceaccount.com", iat: Date().timeIntervalSince1970, exp: Date().adding(.hour, value: 1).timeIntervalSince1970, authorization: authClaim)
        
        var jwt = JWT(header: header, claims: claims)
        
        guard let keyUrl = Bundle.module.url(forResource: "fleet", withExtension: "pem") else {
            SDKUtils.printObject("generateFleetEngineToken cert not found")
            return ""
        }
        
        guard let keyData = try? Data(contentsOf: keyUrl) else { return "" }
        
        let jwtSigner = JWTSigner.rs256(privateKey: keyData)
        
        do {
            return try jwt.sign(using: jwtSigner)
        } catch {
            SDKUtils.printObject("generateFleetEngineToken error", error.localizedDescription)
        }
        
        return ""
    }
}

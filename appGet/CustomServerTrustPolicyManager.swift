//
//  CustomServerTrustPolicyManager.swift
//  appGet
//
//  Created by Amir on 7/8/18.
//  Copyright © 2018 uni. All rights reserved.
//

import Foundation
import Alamofire

class CustomServerTrustPolicyManager: ServerTrustPolicyManager {
    
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        // Check if we have a policy already defined, otherwise just kill the connection
        if let policy = super.serverTrustPolicy(forHost: host) {
            print(policy)
            return policy
        } else {
            return .customEvaluation({ (_, _) -> Bool in
                return false
            })
        }
    }
    
}

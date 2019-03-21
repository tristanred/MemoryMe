//
//  PreferenceManager.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-20.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation

class PreferenceManager
{
    static func GetAllowsTracking() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "allows_tracking");
    }
    
    static func SetAllowsTracking(toValue value: Bool)
    {
        UserDefaults.standard.set(value, forKey: "allows_tracking");
    }
}

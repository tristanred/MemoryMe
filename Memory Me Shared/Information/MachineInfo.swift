//
//  MachineInfo.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-30.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

/**
 * Machine Identification functionalities.
 *
 * These functions can be used to get specific information on an iOS device
 * or a Mac computer.
 *
 */

import Foundation

fileprivate let UUID_KEY_NAME: String = "MACHINE_UUID";

func cycleDeviceID()
{
    if(getDeviceUUID() == nil)
    {
        storeDeviceUUID(generateNewDeviceUUID());
    }
}

func generateNewDeviceUUID() -> UUID
{
    return UUID.init();
}

func getDeviceUUID() -> UUID?
{
    let uidCheck = UserDefaults.standard.value(forKey: UUID_KEY_NAME) as? String;
    
    if let uid = uidCheck
    {
        return UUID.init(uuidString: uid);
    }
    
    return nil;
}

func storeDeviceUUID(_ identifier: UUID)
{
    UserDefaults.standard.set(identifier.uuidString, forKey: UUID_KEY_NAME);
}

func resetDeviceUUID()
{
    UserDefaults.standard.set(UUID.init(), forKey: UUID_KEY_NAME);
}

//
//  TraceManager.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-22.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

func logTrace(withMessage msg: String, export: Bool = false)
{
    let fmt = "Trace: \(msg)";
    
    print(fmt);
    if(export && allowsTracking())
    {
        MSAnalytics.trackEvent(fmt, withProperties: [
            "type": "Trace",
            "ID": getDeviceUUID()?.uuidString ?? ""]);
    }
}

func logTrace(withMessage msg: String, andProperties props: [String:String], export: Bool = false)
{
    let fmt = "Trace: \(msg)";
    
    print(fmt);
    for prop in props
    {
        print("    \(prop.key) = \(prop.value)");
    }
    
    if(export && allowsTracking())
    {
        let additionalProperties = props.merging([
            "type":"Trace",
            "ID": getDeviceUUID()?.uuidString ?? ""], uniquingKeysWith: { a,b in return a });
        
        MSAnalytics.trackEvent(fmt, withProperties: additionalProperties);
    }
}

func logMessage(withMessage msg: String, export: Bool = false)
{
    let fmt = "Message: \(msg)";
    
    print(fmt);
    if(export && allowsTracking())
    {
        MSAnalytics.trackEvent(fmt, withProperties: [
            "type": "Message",
            "ID": getDeviceUUID()?.uuidString ?? ""]);
    }
}

func logWarning(withMessage msg: String, export: Bool = false)
{
    let fmt = "Warning: \(msg)";
    
    print(fmt);
    if(export && allowsTracking())
    {
        MSAnalytics.trackEvent(fmt, withProperties: [
            "type": "Warning",
            "ID": getDeviceUUID()?.uuidString ?? ""]);
    }
}

func logError(withMessage msg: String, export: Bool = false)
{
    let fmt = "Error: \(msg)";
    
    print("[\(ErrorCode.NONE)]",  fmt);
    if(export && allowsTracking())
    {
        MSAnalytics.trackEvent(fmt, withProperties: [
            "type": "Error",
            "code": "\(ErrorCode.NONE)",
            "ID": getDeviceUUID()?.uuidString ?? ""]);
    }
}

func logError(withErrorCode code: ErrorCode, andMessage msg: String, export: Bool = false)
{
    let fmt = "Error: \(msg)";
    
    print("[\(code)]", fmt);
    if(export && allowsTracking())
    {
        MSAnalytics.trackEvent(fmt, withProperties: [
            "type": "Error",
            "code": "\(code)",
            "ID": getDeviceUUID()?.uuidString ?? ""]);
    }
}

func logError(fromErrorClass err: BaseError, export: Bool = false)
{
    let fmt = "Error: \(err.errorName), \(err.errorMessage)";
    
    print("[\(err.errorCode)]", fmt);
    if(export && allowsTracking())
    {
        MSAnalytics.trackEvent(fmt, withProperties: [
            "type": "Error",
            "code": "\(err.errorCode)",
            "ID": getDeviceUUID()?.uuidString ?? ""]);
    }
}

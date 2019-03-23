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

func logTrace(withMessage msg: String)
{
    let fmt = "Trace: \(msg)";
    
    print(fmt);
    MSAnalytics.trackEvent(fmt, withProperties: ["type": "Trace"]);
}

func logMessage(withMessage msg: String)
{
    let fmt = "Message: \(msg)";
    
    print(fmt);
    MSAnalytics.trackEvent(fmt, withProperties: ["type": "Message"]);
}

func logWarning(withMessage msg: String)
{
    let fmt = "Warning: \(msg)";
    
    print(fmt);
    MSAnalytics.trackEvent(fmt, withProperties: ["type": "Warning"]);
}

func logError(withMessage msg: String)
{
    let fmt = "Error: \(msg)";
    
    print("[\(ErrorCode.NONE)]",  fmt);
    MSAnalytics.trackEvent(fmt, withProperties: ["type": "Error", "code": "\(ErrorCode.NONE)"]);
}

func logError(withErrorCode code: ErrorCode, andMessage msg: String)
{
    let fmt = "Error: \(msg)";
    
    print("[\(code)]", fmt);
    MSAnalytics.trackEvent(fmt, withProperties: ["type": "Error", "code": "\(code)"]);
}

func logError(fromErrorClass err: BaseError)
{
    let fmt = "Error: \(err.errorName), \(err.errorMessage)";
    
    print("[\(err.errorCode)]", fmt);
    MSAnalytics.trackEvent(fmt, withProperties: ["type": "Error", "code": "\(err.errorCode)"]);
}

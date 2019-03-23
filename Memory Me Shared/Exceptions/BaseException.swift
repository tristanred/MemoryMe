//
//  BaseException.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-22.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation

enum ErrorCode: Int
{
    case NONE = 0
}

class BaseError : Error
{
    let errorName: String;
    let errorMessage: String;
    let errorCode: ErrorCode;
    
    init(name: String, message: String)
    {
        self.errorName = name;
        self.errorMessage = message;
        self.errorCode = .NONE;
    }
    
    init(name: String, typeCode: ErrorCode, message: String)
    {
        self.errorName = name;
        self.errorMessage = message;
        self.errorCode = typeCode;
    }
}

class UnknownGameError : BaseError
{
    init(message: String)
    {
        super.init(name: "UnknownError", typeCode: ErrorCode.NONE, message: message);
    }
}

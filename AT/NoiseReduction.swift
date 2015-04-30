//
//  NoiseReduction.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

var CONTAINED = 0
var RISING = 1
var DECLINING = -1

func detectTrend(first:Dictionary<NSString,NSString>, second:Dictionary<NSString,NSString>) -> Int {
    var firstHigh : Float = (first["High"])!.floatValue
    var firstLow : Float = (first["Low"])!.floatValue
    var secondHigh : Float = (second["High"])!.floatValue
    var secondLow : Float = (second["Low"])!.floatValue
    
    if firstHigh < secondHigh && firstLow < secondLow {
        
        return RISING
        
    } else if firstHigh > secondHigh && firstLow > secondLow {
        
        return DECLINING
        
    } else {
        
        return CONTAINED
    }
    
}




func mergeAsRising(first:Dictionary<NSString,NSString>, second:Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
    var result : Dictionary<NSString,NSString> = Dictionary()
    
    var firstHigh : Float = (first["High"])!.floatValue
    var firstLow : Float = (first["Low"])!.floatValue
    var secondHigh : Float = (second["High"])!.floatValue
    var secondLow : Float = (second["Low"])!.floatValue
    
    
    result["High"] = "\(max(firstHigh,secondHigh))"
    result["Low"] = "\(max(firstLow,secondLow))"
    
    result["Date"] = first["Date"]
    result["Open"] = result["Low"]
    result["Close"] = result["High"]
    result["Volume"] = first["Volume"]
    result["Adj Close"] = first["Adj Close"]
    
    return result
}



func mergeAsDeclining(first:Dictionary<NSString,NSString>, second:Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
    var result : Dictionary<NSString,NSString> = Dictionary()
    
    var firstHigh : Float = (first["High"])!.floatValue
    var firstLow : Float = (first["Low"])!.floatValue
    var secondHigh : Float = (second["High"])!.floatValue
    var secondLow : Float = (second["Low"])!.floatValue
    
    
    result["High"] = "\(min(firstHigh,secondHigh))"
    result["Low"] = "\(min(firstLow,secondLow))"
    
    result["Date"] = first["Date"]
    result["Open"] = result["High"]
    result["Close"] = result["Low"]
    result["Volume"] = first["Volume"]
    result["Adj Close"] = first["Adj Close"]
    
    
    
    
    
    return result
}



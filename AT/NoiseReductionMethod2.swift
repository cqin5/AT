//
//  NoiseReductionMethod2.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-30.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

func detectTrend2(yesterday:Dictionary<NSString,NSString>, today:Dictionary<NSString,NSString>) -> Int {
    var yesterdayHigh : Float = (yesterday["High"])!.floatValue
    var yesterdayLow : Float = (yesterday["Low"])!.floatValue
    var todayHigh : Float = (today["High"])!.floatValue
    var todayLow : Float = (today["Low"])!.floatValue
    
    if yesterdayHigh < todayHigh && yesterdayLow < todayLow {
        
        return RISING
        
    } else if yesterdayHigh > todayHigh && yesterdayLow > todayLow {
        
        return DECLINING
        
    } else {
        
        return CONTAINED
    }
    
}




func mergeAsRising2(yesterday:Dictionary<NSString,NSString>, today:Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
    var result : Dictionary<NSString,NSString> = Dictionary()
    
    var yesterdayHigh : Float = (yesterday["High"])!.floatValue
    var yesterdayLow : Float = (yesterday["Low"])!.floatValue
    var todayHigh : Float = (today["High"])!.floatValue
    var todayLow : Float = (today["Low"])!.floatValue
    
    result["High"] = "\(max(yesterdayHigh,todayHigh))"
    result["Low"] = "\(max(yesterdayLow,todayLow))"
    
    result["Date"] = today["Date"]
    result["Open"] = result["Low"]
    result["Close"] = result["High"]
    result["Volume"] = NSString(format: "%d", (yesterday["Volume"]!.integerValue + today["Volume"]!.integerValue) / 2)
    result["Adj Close"] = today["Adj Close"]
    
    return result
}



func mergeAsDeclining2(yesterday:Dictionary<NSString,NSString>, today:Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
    var result : Dictionary<NSString,NSString> = Dictionary()
    
    var yesterdayHigh : Float = (yesterday["High"])!.floatValue
    var yesterdayLow : Float = (yesterday["Low"])!.floatValue
    var todayHigh : Float = (today["High"])!.floatValue
    var todayLow : Float = (today["Low"])!.floatValue
    
    
    result["High"] = "\(min(yesterdayHigh,todayHigh))"
    result["Low"] = "\(min(yesterdayLow,todayLow))"
    
    result["Date"] = today["Date"]
    result["Open"] = result["High"]
    result["Close"] = result["Low"]
    result["Volume"] = NSString(format: "%d", (yesterday["Volume"]!.integerValue + today["Volume"]!.integerValue) / 2)
    result["Adj Close"] = today["Adj Close"]
    
    
    
    
    
    return result
}





func cleanUpAsRising2(day: Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
    var result : Dictionary<NSString,NSString> = Dictionary()
    
    result["High"] = day["High"]
    result["Low"] = day["Low"]
    
    result["Date"] = day["Date"]
    result["Open"] = day["Low"]
    result["Close"] = day["High"]
    result["Volume"] = day["Volume"]
    result["Adj Close"] = day["Adj Close"]
    
    return result
}



func cleanUpAsDeclining2(day:Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
    var result : Dictionary<NSString,NSString> = Dictionary()
    
    result["High"] = day["High"]
    result["Low"] = day["Low"]
    
    result["Date"] = day["Date"]
    result["Open"] = day["High"]
    result["Close"] = day["Low"]
    result["Volume"] = day["Volume"]
    result["Adj Close"] = day["Adj Close"]
    
    
    
    
    
    return result
}




func M2(stock:CSV) -> (data: [Dictionary<String,String>], efficiency: Double) {
    var countBeforeMerge = stock.rows.count
    var error = NSErrorPointer()
    var i = 1 as Int
    var flag = CONTAINED
    
    //println("Before merging: \(countBeforeMerge)")
    
    
    while i != stock.rows.count {
//                println("\(i) and \(stock.rows.count)")
        
            
            switch detectTrend2(stock.rows[i-1], stock.rows[i]) {
                
            case RISING:
                
                stock.rows[i] = cleanUpAsRising2(stock.rows[i]) as! [String:String]
                
                flag = RISING
                i++
                
            case DECLINING:
                
                stock.rows[i] = cleanUpAsDeclining2(stock.rows[i]) as! [String:String]
                
                flag = DECLINING
                i++
                
            default:
                mergeLoop: while detectTrend2(stock.rows[i-1], stock.rows[i]) == CONTAINED {
                    //println("i: \(i), and \(stock.rows[i+1])")
                    //println("\(i) and \(stock.rows.count-1)")
                    switch flag {
                        
                    case RISING:
                        stock.rows[i] = mergeAsRising2(stock.rows[i-1], stock.rows[i]) as! [String:String]
//                        
//                        if i == stock.rows.count-1 {
//                            stock.rows[i] = cleanUpAsRising2(stock.rows[i]) as! [String:String]
//                        }
                        
                    case DECLINING:
                        stock.rows[i] = mergeAsDeclining2(stock.rows[i-1], stock.rows[i]) as! [String:String]
                        
//                        if i == stock.rows.count-1 {
//                            stock.rows[i] = cleanUpAsDeclining2(stock.rows[i]) as! [String:String]
//                        }
//                        
                    default:
                        stock.rows[i] = mergeAsDeclining2(stock.rows[i-1], stock.rows[i]) as! [String:String]
                    }
                    
                    stock.rows.removeAtIndex(i-1)
                    
                    
//                    i++
                    
                    if i+1 > stock.rows.count {
                        break mergeLoop
                    }
                }
                
                
            }
            
        
        //           println(file.rows[i]["High"]!)
        
        
        
    }
    
    var countAfterMerge = stock.rows.count
    //println("After merging: \(countAfterMerge)")
    var efficiency : Double = Double(countBeforeMerge-countAfterMerge) / Double(countBeforeMerge) * 100
    
    //println(NSString(format: "%.2f%%", efficiency))
    
    return (stock.rows, efficiency)
    
    
    
}



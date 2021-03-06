//
//  method1.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation


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
    result["Volume"] = NSString(format: "%d", (first["Volume"]!.integerValue + second["Volume"]!.integerValue) / 2)
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
    result["Volume"] = NSString(format: "%d", (first["Volume"]!.integerValue + second["Volume"]!.integerValue) / 2)
    result["Adj Close"] = first["Adj Close"]
    
    
    
    
    
    return result
}





func cleanUpAsRising(day: Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
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



func cleanUpAsDeclining(day:Dictionary<NSString,NSString>) -> Dictionary<NSString,NSString> {
    
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




func M1(stock:CSV) -> (data: [Dictionary<String,String>], efficiency: Double) {
    var countBeforeMerge = stock.rows.count
    var error = NSErrorPointer()
    var i = 0
    var flag = CONTAINED
    
    //println("Before merging: \(countBeforeMerge)")
    
    
    while i != stock.rows.count-1 {
//        println("\(i) and \(stock.rows.count)")
        if true {
            
            switch detectTrend(stock.rows[i], stock.rows[i+1]) {
                
            case RISING:
                
                stock.rows[i] = cleanUpAsRising(stock.rows[i]) as! [String:String]
                
                flag = RISING
                i++
                
            case DECLINING:
                
                stock.rows[i] = cleanUpAsDeclining(stock.rows[i]) as! [String:String]
                
                flag = DECLINING
                i++
                
            default:
                mergeLoop: while detectTrend(stock.rows[i], stock.rows[i+1]) == CONTAINED {
                    //println("i: \(i), and \(stock.rows[i+1])")
                    //println("\(i) and \(stock.rows.count-1)")
                    switch flag {
                        
                    case RISING:
                        stock.rows[i] = mergeAsRising(stock.rows[i], stock.rows[i+1]) as! [String:String]
                    case DECLINING:
                        stock.rows[i] = mergeAsDeclining(stock.rows[i], stock.rows[i+1]) as! [String:String]
                    default:
                        stock.rows[i] = mergeAsDeclining(stock.rows[i], stock.rows[i+1]) as! [String:String]
                    }
                    
                    stock.rows.removeAtIndex(i+1)
                    if i+2 > stock.rows.count {
                        break mergeLoop
                    }
                }
                
                
            }
            
        } else {
            break
        }
        //           println(file.rows[i]["High"]!)
        
        
        
    }
    
    var countAfterMerge = stock.rows.count
    //println("After merging: \(countAfterMerge)")
    var efficiency : Double = Double(countBeforeMerge-countAfterMerge) / Double(countBeforeMerge) * 100
    
    //println(NSString(format: "%.2f%%", efficiency))

    return (stock.rows, efficiency)
    
    
    
}



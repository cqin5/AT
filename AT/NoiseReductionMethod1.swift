//
//  method1.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

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
                flag = RISING
                i++
                
            case DECLINING:
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



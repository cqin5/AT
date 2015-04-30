//
//  method2.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

func method2() {
    
    
    var error = NSErrorPointer()
    
    if var file = CSV(contentsOfURL: NSURL(string: "file:///Volumes/StarTech%201/Dropbox/PommeDePain/test.csv")!, error: error) {
        
        var open : NSString = file.rows[1]["Open"]!
        
        var newFile = NSMutableArray()
        
        
        for i in 0...file.rows.count-2 {
            
            //file.rows[i]["High"] = "0.0"
            
        }
        println("Before merging: \(file.rows.count)")
        var i = 0
        
        var flag = CONTAINED
        while i != file.rows.count-1 {
            
            switch detectTrend(file.rows[i], file.rows[i+1]) {
                
            case RISING:
                flag = RISING
                newFile.addObject(file.rows[i])
                i++
                
            case DECLINING:
                flag = DECLINING
                newFile.addObject(file.rows[i])
                i++
                
            default:
                while detectTrend(file.rows[i], file.rows[i+1]) == CONTAINED {
                    switch flag {
                        
                    case RISING:
                        newFile.addObject(mergeAsRising(file.rows[i], file.rows[i+1]))
                        file.rows.removeAtIndex(i+1)
                    case DECLINING:
                        newFile.addObject(mergeAsDeclining(file.rows[i], file.rows[i+1]))
                        file.rows.removeAtIndex(i+1)
                    default:
                        break
                    }
                    
                    //println("i: \(i), flag: \(flag)")
                    //println(file.rows[i]["High"]!)
                    //println(file.rows[i+1]["High"]!)
                }
                
                
                
                
            }
            //println(file.rows[i]["High"]!)
            
            //println("After merging: \(file.rows.count)\n")
            
        }
        for item in newFile {
            println(item["High"]!)
        }
        println("After merging: \(file.rows.count)\n")
        //println(file.columns["High"])
        
        
        
    }
    
    
}
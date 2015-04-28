//
//  Stock.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

class Stock {
    
    var date = NSDate()
    var dateFormatter = NSDateFormatter()
    
    var open = Float()
    var close = Float()
    
    var high = Float()
    var low = Float()
    
    var adjustedClose = Float()
    
    init(){
       dateFormatter.dateFormat = "yyy"
        
        
        
    }
}
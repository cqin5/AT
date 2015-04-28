//
//  main.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

println("Hello, World!")

for(var i = 0; i < 20; i++){
    if i % 5 == 0 {
        println(i)
    }
    
    i += 3
    println("i=\(i)")
    
}
//
//  main.swift
//  AT
//
//  Created by Chuhan Qin on 2015-04-28.
//  Copyright (c) 2015 Chuhan Qin. All rights reserved.
//

import Foundation

var pathToTestFile = "file:///Users/cqin/Desktop/analyzedStocks/BBRY.csv" //"file:///Users/cqin/Desktop/test.csv"
var pathToTestResult = "file:///Users/cqin/Desktop/BBRY-M2.csv" //"file:///Users/cqin/Desktop/test-result.csv"


var pathToDesktop = "file:///Users/cqin/Desktop/list/"
var savePath = "file:///Users/cqin/Desktop/analyzedStocks/"


var newDataSavePath = "file:///Volumes/StarTech%201/Dropbox/PommeDePain/New%20Data/"


func analyzeStocksAtPath(){
    
    let start = NSDate()
    
    var bestScore = Double()
    
    var score : Double = 0.0
    
    if let list = CSV(contentsOfURL: NSURL(string: "file:///Volumes/StarTech%201/Dropbox/PommeDePain/list.csv")!, error: nil){
        //        println(list.rows.count)
        for i in 0...list.rows.count-1 {
            
            let fileStart = NSDate()
            autoreleasepool({
                
                println(list.rows[i]["Filename"]! + " \(i)/\(list.rows.count)")
                
                var csvFile = CSV(contentsOfURL: NSURL(string: pathToDesktop + list.rows[i]["Filename"]!)!, error: nil)!
                
                var analysisResult = M1(csvFile)
                
                var data = analysisResult.data
                
                
                
                writeToFile(list.rows[i]["Filename"]!, data)
                
                
                
                if score < analysisResult.efficiency {
                    score = analysisResult.efficiency
                    println(NSString(format: "New efficiency record: %.2f%%", score))
                }
                
            })
            
            //            println("Analyzing current file took \(NSDate().timeIntervalSinceDate(fileStart)) seconds.\n")
            
        }
    }
    
    
    var formattedScore = NSString(format: "%.2f%%", score)
    println("Analyzing all files took \(NSDate().timeIntervalSinceDate(start)) seconds. Highest efficiency achieved: \(formattedScore)\n")
}


func testAnalyzeStockAtPath(path:String){

    var csvFile = CSV(contentsOfURL: NSURL(string: path)!, error: nil)!
    var m1 = M1(csvFile)
    
    writeToFile("test-result.csv", m1.data)
    
    for row in m1.data {
        
//        print(row["Open"]! + "\t ")
//        print(row["High"]! + "\t ")
//        print(row["Low"]! + "\t ")
//        println(row["Close"]!)
//        
    }
    
}



func testMethod2(path:String){
    
    var csvFile = CSV(contentsOfURL: NSURL(string: path)!, error: nil)!
    var m2 = M2(csvFile)
    
    for row in m2.data {
        print(row["Date"]! + "\t ")
                        print(row["Open"]! + "\t ")
        print(row["High"]! + "\t ")
        print(row["Low"]! + "\t ")
                        println(row["Close"]!)
        
    }
    
    
    writeToFileAtPath("file:///Users/cqin/Desktop/BBRY-M2.csv", m2.data)
    
    
    
}



func writeToFile(name: String, data:[Dictionary<String,String>]){
    
    var headers = "Date,Open,High,Low,Close,Volume,Adj Close"
    var rows = headers + "\n"
    
    for row in data {
        
        rows += row["Date"]! + "," + row["Open"]! + "," + row["High"]! + "," + row["Low"]! + "," + row["Close"]! + "," + row["Volume"]! + "," + row["Adj Close"]! + "\n"
        
        
    }
    
//    println(rows)
    var error = NSErrorPointer()
    if !rows.writeToURL(NSURL(string: newDataSavePath + name)!, atomically: true, encoding: NSUTF8StringEncoding, error: error) {
        println(error.debugDescription)
    }
    
    
}

func writeToFileAtPath(fullPath: String, data:[Dictionary<String,String>]){
    
    var headers = "Date,Open,High,Low,Close,Volume,Adj Close"
    var rows = headers + "\n"
    
    for row in data {
        
        rows += row["Date"]! + "," + row["Open"]! + "," + row["High"]! + "," + row["Low"]! + "," + row["Close"]! + "," + row["Volume"]! + "," + row["Adj Close"]! + "\n"
        
        
    }
    
    //    println(rows)
    var error = NSErrorPointer()
    if !rows.writeToURL(NSURL(string: fullPath)!, atomically: true, encoding: NSUTF8StringEncoding, error: error) {
        println(error.debugDescription)
    }
    
    
}


func runM2AtPath(path:String){
    
    var error = NSErrorPointer()
    var newPath = "file:///Users/cqin/Desktop/analyzedStocks/BBRY.csv"
    
    if let csvFile = CSV(contentsOfURL: NSURL(string: path as String)!, error: error) {
        var m2 = M2(csvFile)
    
//    for row in m2.data {
//        print(row["Date"]! + "\t ")
//        print(row["Open"]! + "\t ")
//        print(row["High"]! + "\t ")
//        print(row["Low"]! + "\t ")
//        println(row["Close"]!)
//        
//    }
    
        var savedFilePath = "file:///Users/" + NSUserName() + "/Desktop/" + path.lastPathComponent
        println(savedFilePath)
        writeToFileAtPath(savedFilePath, m2.data)
    } else {
        println(error.debugDescription)
    }
//    println(NSUserName())
    println("Saved to: " +  NSUserName() + "/Desktop/" + path.lastPathComponent)
}



func runM2OnAllFilesAtPath(){
    
    let start = NSDate()
    
    var bestScore = Double()
    
    var score : Double = 0.0
    
    if let list = CSV(contentsOfURL: NSURL(string: "file:///Volumes/StarTech%201/Dropbox/PommeDePain/list.csv")!, error: nil){
        //        println(list.rows.count)
        for i in 0...list.rows.count-1 {
            
            let fileStart = NSDate()
            autoreleasepool({
                
                println(list.rows[i]["Filename"]! + " \(i)/\(list.rows.count)")
                
                var csvFile = CSV(contentsOfURL: NSURL(string: pathToDesktop + list.rows[i]["Filename"]!)!, error: nil)!
                var analysisResult = M2(csvFile)
                var data = analysisResult.data
                
                writeToFile(list.rows[i]["Filename"]!, data)
                
                
                
                if score < analysisResult.efficiency {
                    score = analysisResult.efficiency
                    println(NSString(format: "New efficiency record: %.2f%%", score))
                }
                
            })
            
            //            println("Analyzing current file took \(NSDate().timeIntervalSinceDate(fileStart)) seconds.\n")
            
        }
    }
    
    
    var formattedScore = NSString(format: "%.2f%%", score)
    println("Analyzing all files took \(NSDate().timeIntervalSinceDate(start)) seconds. Highest efficiency achieved: \(formattedScore)\n")
    
    
    
    
}



func start(){
    
    //var inputData = NSFileHandle.fileHandleWithStandardInput().availableData
    var input = NSString(data: NSFileHandle.fileHandleWithStandardInput().availableData, encoding:NSUTF8StringEncoding)
    //println(input!)
    var path = input?.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
    runM2AtPath(path!)
//    print("Enter name: ")
}

//testAnalyzeStockAtPath(pathToTestFile)
//analyzeStocksAtPath()
//testMethod2(pathToTestFile)
//start()

runM2OnAllFilesAtPath()


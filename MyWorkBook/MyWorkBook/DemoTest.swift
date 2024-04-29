//
//  DemoTest.swift
//  MyWorkBook
//
//  Created by yuqing on 2024/3/15.
//

import UIKit

class DemoTest: NSObject {
    
    struct Thing: Identifiable {
        let id = "thing"
    }
    
    let thing: any Identifiable<String> = Thing()
    
    var thing1: (any Identifiable)?
    
    func test(p: any Identifiable) {
        
        thing1 = p
    }
    //调用方法test(thing)会在iOS16以下崩溃
}

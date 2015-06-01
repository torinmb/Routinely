//
//  Task.swift
//  Routinely
//
//  Created by Torin Blankensmith on 5/26/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.
//

import UIKit

class Task: NSObject {

    var time: NSTimeInterval
    var text: String
    
    init(text: String) {
        self.text = text
        self.time = NSTimeInterval()
    }
}

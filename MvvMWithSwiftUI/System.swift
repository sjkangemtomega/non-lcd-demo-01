//
//  System.swift
//  MvvMWithSwiftUI
//
//  Created by kangseokju on 2021/05/15.
//

import Foundation
import UIKit

struct SystemUtil {
    static func preventSleep() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    static func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    static func delay(_ delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {})
    }
    
    
    
}

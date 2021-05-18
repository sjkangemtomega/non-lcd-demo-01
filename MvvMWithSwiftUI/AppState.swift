//
//  AppState.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI

class AppState: ObservableObject {
    
    @Published var showActionSheet: Bool = false
    @Published var selectedItem: File? = nil
    @Published var isDeviceConnected: Bool = false
    @Published var isDeviceConnecting: Bool = false
    @Published var isSignedIn: Bool = false
    
    init() {
        //
    }
    
    deinit {
        //
    }
    
    
}

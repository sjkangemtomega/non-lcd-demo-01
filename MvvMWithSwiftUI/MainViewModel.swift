//
//  MainViewModel.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
//    @Published var selectionTab: Int = 0
    
    var selectedTab: MainView.Tab = .home {
        willSet { objectWillChange.send() }
    }
    
    init() {
        //
    }
    
    deinit {
        //
    }
    
    
}

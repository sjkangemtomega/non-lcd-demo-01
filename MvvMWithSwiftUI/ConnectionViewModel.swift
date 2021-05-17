//
//  ConnectionViewModel.swift
//  MvvMWithSwiftUI
//
//  Created by kangseokju on 2021/05/15.
//

import Combine
import Foundation

class ConnectionViewModel: ObservableObject {
    
    var bag: Set<AnyCancellable>?
    
    init() {
        bag = Set<AnyCancellable>()
    }
    
    deinit {
        bag?.removeAll()
    }
    
    
}

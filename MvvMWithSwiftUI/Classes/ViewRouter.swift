//
//  ViewRouter.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/15.
//

import Foundation
import SwiftUI
import Combine

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .home
    
}

enum Page {
    case home
    case connect
    case video
    case file
    case myinfo
}


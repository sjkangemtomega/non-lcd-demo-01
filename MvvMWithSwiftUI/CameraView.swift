//
//  ThirdView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewRouter: ViewRouter
    @ObservedObject var presenter: VideoAnalyzerPresenter
    
    var body: some View {
        ZStack {
            VideoAnalyzerView(presenter: presenter, viewRouter: viewRouter)
        }
        .onAppear() {
            if !appState.isDeviceConnected {
                viewRouter.currentPage = .connect
            }
        }
    }
}


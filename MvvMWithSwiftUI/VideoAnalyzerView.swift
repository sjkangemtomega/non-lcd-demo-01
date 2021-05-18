//
//  VideoAnalyzerView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/12.
//

import SwiftUI
import UIKit
import AVFoundation

struct VideoAnalyzerView: View {
    @ObservedObject var presenter: VideoAnalyzerPresenter
    @StateObject var viewRouter: ViewRouter
    @State var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        ZStack {
            CALayerPreviewView(caLayer: presenter.previewLayer)
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: viewRouter.currentPage) { newValue in
                    switch newValue {
                    case .home:
                        print("\(newValue)")
                    case .connect:
                        print("\(newValue)")
                    case .video:
                        print("\(newValue)")
                    case .file:
                        print("\(newValue)")
                    case .myinfo:
                        print("\(newValue)")
                    }
                }
        .onAppear {
            presenter.apply(inputs: .onAppear)
        }
        .onDisappear {
            presenter.apply(inputs: .onDisappear)
        }
        .onRotate(perform: { newOrientation in
            self.orientation = newOrientation
            
//            presenter.apply(inputs: .onDisappear)
//            presenter.apply(inputs: .onAppear)
        })
        
        
    }
}

struct CALayerPreviewView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    var caLayer: CALayer
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewControlelr = UIViewController()
        viewControlelr.view.layer.addSublayer(caLayer)
        caLayer.frame = viewControlelr.view.layer.frame
        return viewControlelr
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}

struct VideoAnalyzerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoAnalyzerView(presenter: VideoAnalyzerPresenter(), viewRouter: ViewRouter())
    }
}


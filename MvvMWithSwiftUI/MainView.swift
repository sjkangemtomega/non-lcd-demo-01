//
//  MainView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI

struct MainView: View {
//    @ObservedObject var viewModel: MainViewModel
    @EnvironmentObject var appState: AppState
    @StateObject var viewRouter: ViewRouter
    @State var presentingConnectionView: Bool = false
    @ObservedObject var presenter: VideoAnalyzerPresenter
    
    var body: some View {
        TabView(selection: $viewRouter.currentPage,
                content:  {
                    HomeView()
                        .tabItem {
                            FirstMenuView()
                        }
                        .tag(Tab.home)
                    
                    ConnectView()
                        .tabItem {
                            SecondMenuView()
                        }
                        .tag(Tab.connect)

                    CameraView(viewRouter: viewRouter, presenter: presenter)
                        .tabItem {
                            ThirdMenuView()
                        }
                        .tag(Tab.video)
                    
                    FileView()
                        .tabItem {
                            ForthMenuView()
                        }
                        .tag(Tab.file)
                    
                    SettingsView()
                        .tabItem {
                            FifthMenuView()
                        }
                        .tag(Tab.info)
                }
        )
        .sheet(isPresented: $presentingConnectionView, content: {
            DeviceConnectionView(viewRouter: viewRouter, presentingConnectionView: $presentingConnectionView)
        })
        .accentColor(Color.blue) // when selected
        .onChange(of: viewRouter.currentPage) { newValue in
            switch newValue {
            case .home:
                print("\(newValue)")
            case .connect:
                presentingConnectionView = true
            case .video:
                print("\(newValue)")
            case .file:
                print("\(newValue)")
            case .myinfo:
                print("\(newValue)")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewRouter: ViewRouter(), presenter: VideoAnalyzerPresenter())
    }
}

extension MainView {
    enum Tab: Hashable {
        case home
        case connect
        case video
        case file
        case info
    }
    
    private struct FirstMenuView: View {
        var body: some View {
            VStack {
                Image(systemName: "house")
                Text("home")
            }
        }
    }
    
    private struct SecondMenuView: View {
        var body: some View {
            VStack {
                Image(systemName: "wifi")
                Text("Connect")
            }
        }
    }
    
    private struct ThirdMenuView: View {
        var body: some View {
            VStack {
                Image(systemName: "iphone.homebutton.radiowaves.left.and.right")
                Text("Video")
            }
        }
    }
    
    private struct ForthMenuView: View {
        var body: some View {
            VStack {
                Image(systemName: "externaldrive")
                Text("File")
            }
        }
    }
    
    private struct FifthMenuView: View {
        var body: some View {
            VStack {
                Image(systemName: "person.circle")
                Text("MyInfo")
            }
        }
    }
}

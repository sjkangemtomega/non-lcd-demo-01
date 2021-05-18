//
//  HomeView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/15.
//

import SwiftUI
import Combine

struct TestMainView: View {
    @StateObject var viewRouter: ViewRouter
    @EnvironmentObject var appState: AppState
    @State var presentingConnectionView: Bool = false
    @ObservedObject var presenter: VideoAnalyzerPresenter
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                 switch viewRouter.currentPage {
                 case .home:
                     HomeView()
                 case .connect:
                     ConnectView()
                 case .video:
                    CameraView(viewRouter: viewRouter, presenter: presenter)
                 case .file:
                     FileView()
                 case .myinfo:
                     SettingsView()
                 }
                
                Spacer()

                HStack(alignment: .center) {
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Home")
                    
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .connect, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "wifi", tabName: "Connect")
                  
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .video, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "video", tabName: "Video")
                        .onTapGesture {
                            if !appState.isDeviceConnected {
                                viewRouter.currentPage = .connect
                            } else {
                                viewRouter.currentPage = .video
                            }
                          }
    //                    .offset(y: -geometry.size.height/20/2)
                    
//                    ZStack {
//                        Circle()
//                             .foregroundColor(.white)
//                             .frame(width: geometry.size.width/7, height: geometry.size.width/7)
//                             .shadow(radius: 4)
//
//                         Image(systemName: "iphone.homebutton.radiowaves.left.and.right")
//                             .resizable()
//                             .aspectRatio(contentMode: .fit)
//                             .frame(width: geometry.size.width/7-6 , height: geometry.size.width/7-6)
//                            .foregroundColor(appState.isDeviceConnected ? Color.blue:Color.gray)
//                     }
                    
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .file, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "externaldrive", tabName: "File")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .myinfo, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "MyInfo")
                } //eoh
                .frame(width: geometry.size.width - 20, height: geometry.size.height/10)
                .background(Color.blue.opacity(0.1).shadow(radius: 2))
                .cornerRadius(15)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
//                .offset(x: -10)
            } //eov
            .edgesIgnoringSafeArea(.bottom)
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
         } //eog
        .onRotate(perform: { newOrientation in
        })
    }
}

struct TabBarIcon: View {
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
     
    let width, height: CGFloat
    let systemIconName, tabName: String
     
     var body: some View {
         VStack {
             Image(systemName: systemIconName)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: width, height: height)
                 .padding(.top, 10)
                .foregroundColor((viewRouter.currentPage == assignedPage) ? Color.blue:Color.black)
             Text(tabName)
                 .font(.footnote)
            Spacer()
         }
         .onTapGesture {
            viewRouter.currentPage = assignedPage
          }
         .padding(.horizontal, -4)
     }
}

struct TestMainView_Previews: PreviewProvider {
    static var previews: some View {
        TestMainView(viewRouter: ViewRouter(), presenter: VideoAnalyzerPresenter())
    }
}

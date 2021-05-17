//
//  DeviceConnectionView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/14.
//

import SwiftUI
import Combine

struct DeviceConnectionView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewRouter: ViewRouter
    @State var progressValue: Float = 0.0
    @State var showCompleteMessage: Bool = false
    @Binding var presentingConnectionView: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing) {
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        if !appState.isDeviceConnecting {
                            viewRouter.currentPage = .home
                            presentingConnectionView = false
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .accentColor(appState.isDeviceConnecting ? Color.gray : Color.blue)
                            .frame(width: 25, height: 25)
                    })
                    .padding()
                }
                Spacer()
            }
            
            if !appState.isDeviceConnecting {
                VStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Image(systemName: appState.isDeviceConnected ? "wifi" : "wifi.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(appState.isDeviceConnected ? Color.blue : Color.gray)
                            .frame(width: 150, height: 150, alignment: .center)
                            .padding(.bottom, 25)
                        
                        ConnectButtonView(presentingConnectionView: $presentingConnectionView, progressValue: $progressValue, showCompleteMessage: $showCompleteMessage)
                    }
                }
            } else {
                ProgressBarView(progress: self.$progressValue)
                                        .frame(width: 150.0, height: 150.0)
                                        .padding(40.0)
            }
        }
        .onAppear() {
            viewRouter.currentPage = .home
            appState.isDeviceConnecting = false
        }
    }
}

fileprivate struct ConnectButtonView: View {
    @EnvironmentObject var appState: AppState
    @Binding var presentingConnectionView: Bool
    @Binding var progressValue: Float
    @Binding var showCompleteMessage: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {
                if !appState.isDeviceConnected {
                    appState.isDeviceConnecting = true
                    
                    print("not connected")
                    
                    var bag = Set<AnyCancellable>()
                    let concurrentQueue: DispatchQueue = DispatchQueue(label: "ConcurrentQueue", qos: .default, attributes: .concurrent)
                    let next = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
                    
                    next.subscribe(on: concurrentQueue)
                        .sink(receiveValue: { value in
                            print("\(value)")
                            if self.progressValue == 1 {
                                next.upstream.connect().cancel()
                                bag.removeAll()
                                
                                appState.isDeviceConnecting = false
                                appState.isDeviceConnected = true
                                SystemUtil.delay(1.5, closure: closeView)
                            }
                            
                            incrementProgress()
                            print(self.progressValue)
                        })
                        .store(in: &bag)
                    
                    // discover
                    
                    
                    // connect device
                    
                    
                } else {
                    appState.isDeviceConnected = false
                    SystemUtil.delay(1, closure: closeView)
                }
            }, label: {
                Text(appState.isDeviceConnected ? "Disconnect" : "Connect")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(appState.isDeviceConnected ? Color.blue:Color.gray)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(appState.isDeviceConnected ? Color.blue:Color.gray, lineWidth: 5)
                    )
            })
        }
    }
    
    func incrementProgress() {
        let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
        self.progressValue = min(1.0, self.progressValue + randomValue)
    }
    
    private func closeView() {
        self.presentingConnectionView = false
    }
}

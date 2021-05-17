//
//  MvvMWithSwiftUIApp.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI
import UIKit

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        print(#function)
        #endif
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if DEBUG
        print(#function)
        #endif
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        #if DEBUG
        print(#function)
        #endif
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        #if DEBUG
        print(#function)
        #endif
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        #if DEBUG
        print(#function)
        #endif
    }
    
    //MARK: - Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //
    }
    
    // handle deep links
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        #if DEBUG
        print(#function)
//        print(url)
        #endif
        
        return true
    }
}

// MARK: - Application EntryPoint
@main
struct AppMain: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    static let presenter = VideoAnalyzerPresenter()
    
    let mainView = MainView(viewRouter: ViewRouter(), presenter: presenter)
    let testMainView = TestMainView(viewRouter: ViewRouter(), presenter: presenter)
    let appState = AppState()
    
    init() {
        #if DEBUG
        print("init")
        #endif
        
        // FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            testMainView
                .environmentObject(appState)
                .onOpenURL(perform: {url in
                    #if DEBUG
                    print("\(#function): \(url)")
                    #endif
                })
                .onContinueUserActivity("Activity", perform: { _ in
                    
                })
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                print("Scene is active")
            case .inactive:
                print("Scene is inactive")
            case .background:
                print("Scene is background")
            @unknown default:
                break
            }
        }
    }
}




//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    lazy var appState = AppState()
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//        let contentView = ContentView()
//            .environmentObject(appState)
//        ...
//    }
//
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        // Parse the deep link
//        if /*Deep link leads to the More tab*/ {
//            appState.selectedTab = .home
//            appState.showActionSheet = true
//        }
//    }
//}



import SwiftUI

struct WiFiView : View {
    @ObservedObject var wifi: Settings
    
    var body: some View {
        Group() {
            Picker(selection: $wifi.type, label: WifiContainer(wifi: wifi)) {
                ForEach(0 ..< wifi.types.count) {
                    Text(self.wifi.types[$0]).tag($0).font(.system(size: 20))
                }
            }
            if wifi.type == 1 {
                HStack {
                    Text("SEARCHING FOR A NETWORK...")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .font(.system(.subheadline))
                    ActivityIndicator(style: .medium)
                }
            }
        }
    }
}

//WiFiView.swift
struct WifiContainer: View {
    @ObservedObject var wifi: Settings
    
    var body: some View {
        HStack {
            Image(systemName: "wifi")
                .resizable()
                .cornerRadius(12)
                .frame(width: 25, height: 25)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(wifi.isWifiOn ? .blue:.gray)
            Text("WiFi")
                .foregroundColor(.blue)
                .font(.system(size: 18))
        }
    }
}

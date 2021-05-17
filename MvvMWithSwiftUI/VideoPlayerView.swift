//
//  VideoPlayerView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/16.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let fileName: String
    let fileExtension: String
    let url: String
    let resourceType: ResourceType
    
    var body: some View {
        ZStack {
            switch resourceType {
            case ResourceType.file:
                VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: "\(fileName)", withExtension: "\(fileExtension)")!))
            case ResourceType.url:
                VideoPlayer(player: AVPlayer(url:  URL(string: "\(url)")!))
            }
        }
    }
}

enum ResourceType {
    case file
    case url
}



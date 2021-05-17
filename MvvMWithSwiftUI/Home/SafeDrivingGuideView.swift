//
//  SafeDrivingGuideView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/14.
//

import SwiftUI

struct SafeDrivingGuideView: View {
    let dirivingGuides: [SafeDrivingGuide]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(dirivingGuides, id: \.self) { guide in
                    DrivingGuideDetailView(guide: guide)
                        .padding(.leading, 10)
                }
                .background(Color.white)
                
                Spacer()
            }
        }
    }
}

fileprivate struct DrivingGuideDetailView: View {
    let guide: SafeDrivingGuide
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text(suggestion.title)
//                .font(.system(.headline, design: .rounded))
//                .foregroundColor(.black)
            
            Image(guide.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200)
                .cornerRadius(5.0)
                .overlay(ImageOverlay(message: guide.title), alignment: .bottomTrailing)
            
            Spacer()
        }
        .frame(width: 200, height: 175)
    }
}

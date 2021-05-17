//
//  TodaysSuggestionView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/14.
//

import SwiftUI

struct TodaysSuggestionView: View {
    let suggestions: [SuggestionDrivingInfo]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(suggestions, id: \.self) { suggestion in
                    SuggestionDetailView(suggestion: suggestion)
                        .padding(.leading, 10)
                }
                .background(Color.white)
                
                Spacer()
            }
        }
    }
}

fileprivate struct SuggestionDetailView: View {
    let suggestion: SuggestionDrivingInfo
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text(suggestion.title)
//                .font(.system(.headline, design: .rounded))
//                .foregroundColor(.black)
            
            Image(suggestion.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200)
                .cornerRadius(5.0)
                .overlay(ImageOverlay(message: suggestion.title), alignment: .bottomTrailing)
            
            Spacer()
        }
        .frame(width: 200, height: 175)
    }
}

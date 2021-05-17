//
//  VisitedPlaceView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/14.
//

import SwiftUI

struct VisitedPlaceView: View {
    let visitedPlaces: [MyVisitedPlace]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(visitedPlaces, id: \.self) { place in
                    PlaceDetailView(place: place)
                        .padding(.leading, 10)
                }
                .background(Color.white)
                
                Spacer()
            }
        }
    }
}

fileprivate struct PlaceDetailView: View {
    let place: MyVisitedPlace
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text(suggestion.title)
//                .font(.system(.headline, design: .rounded))
//                .foregroundColor(.black)
            
            Image(place.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200)
                .cornerRadius(5.0)
                .overlay(ImageOverlay(message: place.title), alignment: .bottomTrailing)
            
            Spacer()
        }
        .frame(width: 200, height: 175)
    }
}

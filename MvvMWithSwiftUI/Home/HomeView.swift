//
//  FirstView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView(searchText: $searchText)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .padding(.bottom, 5)
                    
                    BodyView()
                        .padding(.bottom, 10)

                    Spacer()
                 }
            }
            .navigationBarTitle("EMTOMEGA Inc", displayMode: .automatic)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ZStack(alignment: .topLeading) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 10, height: 10, alignment: .topLeading)
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                        })
                    }
                }
            }
        }
    }
}

private struct HeaderView: View {
    @Binding var searchText: String
    var body: some View {
        SearchBar(text: $searchText)
    }
}

private struct BodyView: View {
    let myVisitedPlaces = TestData.visitedPlaces
    let todaySuggetions = TestData.suggestions
    let safeDrivingGuides = TestData.drivingGuides
    
    var body: some View {
        VStack {
            VStack {
                SectionDividerView(dividerTitle: "Driving Guides")
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                HStack {
                    SafeDrivingGuideView(dirivingGuides: safeDrivingGuides)
                        .padding(.leading, 10)
                    Spacer()
                }
            
                SectionDividerView(dividerTitle: "My Visited Places")
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                HStack {
                    VisitedPlaceView(visitedPlaces: myVisitedPlaces)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                SectionDividerView(dividerTitle: "Today's Suggestion")
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                HStack {
                    TodaysSuggestionView(suggestions: todaySuggetions)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

fileprivate struct BottomView: View {
    var body: some View {
        Text("Bottom")
    }
}

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
 
    var body: some View {
        HStack {
            TextField("Search for something...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SectionDividerView: View {
    let dividerTitle: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text("\(dividerTitle)")
                .padding(.leading, 10)
            
            Spacer()
        }
        .frame(height: 25)
        .cornerRadius(5)
        .background(Color.gray.opacity(0.10))
    }
}

struct ImageOverlay: View {
    let message: String
    
    var body: some View {
        ZStack {
            Text("\(message)")
                .font(.callout)
                .padding(6)
                .foregroundColor(.white)
        }.background(Color.black)
        .opacity(0.7)
        .cornerRadius(10.0)
        .padding(6)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



//
//  ForthView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import SwiftUI

struct FileView: View {
    @EnvironmentObject var appState: AppState
    @State private var isPresented = false
    
//    var onRefresh: () -> Void
//    @State var refresh:Bool = false
    
    @State var files: [File] = [
        File(name: "2021-01-01,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-02,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-02,09:00, 000002", file: "sample.mp4"),
        File(name: "2021-01-04,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-05,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-06,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-07,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-08,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-09,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-10,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-11,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-12,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-13,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-14,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-15,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-16,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-17,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-18,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-19,09:00, 000001", file: "sample.mp4"),
        File(name: "2021-01-20,09:00, 000001", file: "sample.mp4")
    ]
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                List(files) { file in
                    HStack {
                        Image(systemName: "video")
                            .padding(.trailing, 5)
                        Text("\(file.name)")
                        Spacer()
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Image(systemName: "chevron.forward")
                        })
                        .padding(.trailing, 15)
                    }
                    .fullScreenCover(isPresented: $isPresented, content: {
                        FileDetailView(file: file)
                    })
                }
                .navigationBarTitle("Downloaded Files", displayMode: .automatic)
            }
        }
    }
}

private struct FileDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let file: File
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
               Image(systemName: "video")
                .padding(.trailing, 5)
                Text(file.name)
                    .foregroundColor(.white)
            }
            VStack {
                VideoPlayerView(fileName: String(file.file.split(separator: ".")[0]), fileExtension: String(file.file.split(separator: ".")[1]), url: "", resourceType: .file)
            }
        }
    }
}

struct File: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var file: String
}

//struct RefreshControl: View {
//    var coordinateSpace: CoordinateSpace
//    var onRefresh: ()->Void
//    @State var refresh: Bool = false
//    var body: some View {
//        GeometryReader { geo in
//            if (geo.frame(in: coordinateSpace).midY > 50) {
//                Spacer()
//                    .onAppear {
//                        if refresh == false {
//                            onRefresh() ///call refresh once if pulled more than 50px
//                        }
//                        refresh = true
//                    }
//            } else if (geo.frame(in: coordinateSpace).maxY < 1) {
//                Spacer()
//                    .onAppear {
//                        refresh = false
//                        ///reset  refresh if view shrink back
//                    }
//            }
//            //Add Animation
//        }
//    }
//}

//struct ForthView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView()
//    }
//}

//
//  VideoRecordingView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/12.
//

import SwiftUI

struct RecordingView: View {
    @State private var timer = 5
    @State private var onComplete = false
    @State private var recording = false
    
    var body: some View {
        ZStack {
            VideoRecordingView(timeLeft: $timer, onComplete: $onComplete, recording: $recording)
            VStack {
                Button(action: {
                    self.recording.toggle()
                }, label: {
                    Text("Toggle Recording")
                })
                .foregroundColor(.white)
                .padding()
                
                Button(action: {
                    self.timer -= 1
                }, label: {
                    Text("Toggle Timer")
                })
                .foregroundColor(.white)
                .padding()
                
                Button(action: {
                    self.onComplete.toggle()
                }, label: {
                    Text("Toggle Completion")
                })
                .foregroundColor(.white)
                .padding()
                
            }
        }
    }
}

struct VideoRecordingView: UIViewRepresentable {
    @Binding var timeLeft: Int
    @Binding var onComplete: Bool
    @Binding var recording: Bool
    
    func makeUIView(context: UIViewRepresentableContext<VideoRecordingView>) -> PreviewView {
        let recordingView = PreviewView()
        recordingView.onComplete = {
            self.onComplete = true
        }
        
        recordingView.onRecord = { timeLeft, totalShakes in
            self.timeLeft = timeLeft
            self.recording = true
        }
        
        recordingView.onReset = {
            self.recording = false
            self.timeLeft = 30
        }
        
        return recordingView
    }
    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//    }
    
    func updateUIView(_ uiViewController: PreviewView, context: UIViewRepresentableContext<VideoRecordingView>) {
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}

//
//  FrameExtractionDelegate.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/11.
//

import UIKit
import AVFoundation

protocol FrameExtractorDelegate: class {
    func captured(image: UIImage)
}

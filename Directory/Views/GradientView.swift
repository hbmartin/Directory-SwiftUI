//
//  GradientView.swift
//  Directory
//
//  Created by Harold Martin on 1/5/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import Shift
import SwiftUI

struct GradientView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var lightColors = [UIColor.orange, UIColor.purple]
    var darkColors = [UIColor.purple, UIColor(red: 0, green: 0.1294, blue: 0.3569, alpha: 1.0)]

    func makeUIView(context: Context) -> ShiftView { ShiftView() }

    func updateUIView(_ uiView: ShiftView, context: Context) {
        uiView.setColors(colorScheme == .light ? lightColors : darkColors)
        uiView.startMotionAnimation()
    }
}

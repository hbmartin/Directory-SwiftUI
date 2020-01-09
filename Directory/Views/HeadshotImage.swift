//
//  HeadshotImage.swift
//  Directory
//
//  Created by Harold Martin on 1/8/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct HeadshotImage: View {
    var person: Person

    var body: some View {
        KFImage(
            URL(string: person.headshotUrl ?? ("https://picsum.photos/128?" + person.firstName!))
        )
            .placeholder {
                Image(systemName: "arrow.2.circlepath.circle")
                    .font(.largeTitle)
                    .opacity(0.3)
            }
            .resizable()
            .frame(width: 128, height: 128)
            .cornerRadius(10)
    }
}

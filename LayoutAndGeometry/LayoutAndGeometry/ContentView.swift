//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Eugene Evgen on 09/12/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: proxy.frame(in: .global).minY / fullView.size.height,
                                               saturation: 1,
                                               brightness: 1))
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5,
                                              axis: (x: 0, y: 1, z: 0))
                            .opacity(max(0, min(proxy.frame(in: .global).minY / 200, 1)))
                            .scaleEffect(max(proxy.frame(in: .global).minY / fullView.size.height + 0.5, 0.5))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

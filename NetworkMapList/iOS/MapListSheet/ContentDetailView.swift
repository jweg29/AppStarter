//
//  ContentDetailView.swift
//  MapListSheet
//
//  Created by James Wegner on 8/5/24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct ContentDetailView: View {
    private let listItem: Food

    @State private var mapPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    init(listItem: Food) {
        self.listItem = listItem
    }

    var body: some View {
        VStack {
            ScrollView {
                Map(position: $mapPosition, content: {
                    UserAnnotation()
                })
                .clipShape(Circle())
                .aspectRatio(contentMode: .fit)
                .shadow(color: .black, radius: 6, x: 2, y: 2)
                .padding()
                Spacer()
            }
        }
        .padding()
        .navigationTitle(
            Text("\(listItem.name) \(listItem.emoji)")
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ContentDetailView(listItem: .init(name: "cake", emoji: "🍰",
                                          latitude: 40.7222064,
                                          longitude: -73.9833733)
        )
    }
}


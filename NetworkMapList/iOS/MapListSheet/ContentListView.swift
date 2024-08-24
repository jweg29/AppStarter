//
//  ContentListView.swift
//  MapListSheet
//
//  Created by James Wegner on 8/5/24.
//

import Foundation
import SwiftUI

struct ContentListView: View {
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var selectedDetent: PresentationDetent
    @StateObject private var viewModel = FoodViewModel()

    private let listItems: [Food]

    init(listItems: [Food]) {
        self.listItems = listItems
        self.selectedDetent = .fraction(0.25)
    }

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .display:
                    List(viewModel.foodItems) { listItem in
                        NavigationLink() {
                            ContentDetailView(listItem: listItem)
                        } label: {
                            ContentListCell(listItem: listItem)
                        }
                    }
                    .listStyle(.plain)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("food")
                    .searchable(text: $searchText,
                                placement: .navigationBarDrawer(displayMode: .always),
                                prompt: "Search items")
                    .transition(.opacity)
                case .loading:
                    ProgressView("Loading...")
                        .padding()
                        .transition(.opacity)
                case .error(let error):
                    VStack {
                        Text("Error ⚠️")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.top)

                        Text("\(error.localizedDescription)")
                            .multilineTextAlignment(.center)
                            .padding()

                        Button("Retry") {
                            self.viewModel.fetchFood()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .transition(.opacity)
                }
            }
        }
        .onAppear(perform: {
            self.viewModel.fetchFood()
        })
        .interactiveDismissDisabled()
        .presentationDetents([.fraction(0.25), .medium, .large], selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
        .presentationContentInteraction(.resizes)
    }
}

struct ContentListCell: View {

    let listItem: Food

    var body: some View {
        VStack {
            HStack {
                Text(listItem.name)
                    .font(.title3)
                Spacer()
                Text(listItem.emoji)
                    .font(.title3)
            }
            .padding()
        }
    }
}

#Preview {
    ContentListView(listItems: [
        .init(name: "apple", emoji: "🍎"),
        .init(name: "banana", emoji: "🍌"),
        .init(name: "tomato", emoji: "🍅"),
        .init(name: "potatoe", emoji: "🥔"),
        .init(name: "cucumber", emoji: "🥒"),
        .init(name: "broccoli", emoji: "🥦"),
        .init(name: "cake", emoji: "🍰"),
        .init(name: "pie", emoji: "🥧"),
        .init(name: "sushi", emoji: "🍣"),
        .init(name: "croissant", emoji: "🥐"),
        .init(name: "hot dog", emoji: "🌭"),
        .init(name: "hamburger", emoji: "🍔"),
        .init(name: "pizza", emoji: "🍕"),
        .init(name: "watermelon", emoji: "🍉"),
        .init(name: "blueberry", emoji: "🫐"),
        .init(name: "eggplant", emoji: "🍆"),
        .init(name: "bacon", emoji: "🥓"),
        .init(name: "strawberry", emoji: "🍓"),
        .init(name: "taco", emoji: "🌮"),
        .init(name: "pancakes", emoji: "🥞"),
        .init(name: "bagel", emoji: "🥯"),
        .init(name: "cupcake", emoji: "🧁"),
    ])
}

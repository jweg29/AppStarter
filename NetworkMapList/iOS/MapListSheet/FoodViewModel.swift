//
//  ViewModel.swift
//  MapListSheet
//
//  Created by James Wegner on 8/23/24.
//

import Combine
import Foundation
import SwiftUI

enum ViewModelState {
    case display
    case loading
    case error(Error)
}

final class FoodViewModel: ObservableObject {

    @Published var foodItems: [Food] = []
    @Published  var state = ViewModelState.loading

    private var cancellables = Set<AnyCancellable>()

    func fetchFood() {
        state = .loading
        NetworkService.shared.fetchFood()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching food: \(error)")
                    self.state = .error(error)
                case .finished:
                    self.state = .display
                }
            }, receiveValue: { [weak self] items in
                self?.foodItems = items
            })
            .store(in: &cancellables)
    }
}

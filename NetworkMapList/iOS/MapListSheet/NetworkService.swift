//
//  NetworkService.swift
//  MapListSheet
//
//  Created by James Wegner on 8/22/24.
//

import Combine
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

enum Endpoint {
    case fetchFood

    var url: URL? {
        switch self {
        case .fetchFood:
            URL(string: "http://localhost:3000/api/food")
        }
    }
}

public final class NetworkService: NSObject {

    public static let shared = NetworkService()
    private var cancellables = Set<AnyCancellable>()

    private override init() { }

    func fetchFood() -> AnyPublisher<[Food], Error>   {
        guard let url = Endpoint.fetchFood.url else {
            print("Invalid URL")
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                $0.data
            }
            .decode(type: [Food].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

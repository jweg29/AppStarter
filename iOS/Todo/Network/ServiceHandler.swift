//
//  ServiceHandler.swfit.swift
//  Todo
//
//  Created by James Wegner on 1/1/21.
//

import Foundation

struct ServiceHandler {
    private static let host = "http://localhost:8080/api/"
    private let timeoutInterval: TimeInterval = 30
    
    private enum Endpoints: String {
        case fetchTodo = "todo"
        
        var url: URL? {
            switch self {
            case .fetchTodo:
                return URL(string: ServiceHandler.host + rawValue)
            }
        }
    }
    
    func fetchTodos(completionHandler: @escaping ([Todo]) -> ()) {
        guard let url = Endpoints.fetchTodo.url else {
            print("URL for todos not found")
            return
        }
        
        let urlSession = URLSession(configuration: .default)
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                print("Error fetching todos: \(String(describing: error))")
                DispatchQueue.main.async {
                    completionHandler([])
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler((try? JSONDecoder().decode([Todo].self, from: data)) ?? [])
            }
        }
        dataTask.resume()
    }
}

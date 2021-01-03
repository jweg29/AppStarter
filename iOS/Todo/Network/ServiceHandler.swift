//
//  ServiceHandler.swfit.swift
//  Todo
//
//  Created by James Wegner on 1/1/21.
//

import Foundation

struct ServiceHandler {
    private enum Endpoints: String {
        case fetchTodo = "todo"
        
        func url(forEnv env: Env) -> URL? {
            switch self {
            case .fetchTodo:
                return URL(string: env.host + rawValue)
            }
        }
    }
    
    enum Env: String {
        case debug
        
        var host: String {
            switch self {
            case .debug:
                return "http://localhost:8080/api/"
            }
        }
    }
        
    private let timeoutInterval: TimeInterval = 30
    private let env: Env
    private let session = URLSession(configuration: .default)
    
    init(env: Env = .debug) {
        self.env = env
    }
        
    func fetchTodos(completionHandler: @escaping (Result<[Todo], Error>) -> ()) {
        guard let url = Endpoints.fetchTodo.url(forEnv: self.env) else {
            assertionFailure("Could not form URL for fetchTodo")
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                print("Error fetching todos: \(String(describing: error))")
                DispatchQueue.main.async {
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.success([]))
                    }
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(.success((try? JSONDecoder().decode([Todo].self, from: data)) ?? []))
            }
        }
        dataTask.resume()
    }
}

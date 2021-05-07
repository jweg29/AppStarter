//
//  ServiceHandler.swfit.swift
//  Todo
//
//  Created by James Wegner on 1/1/21.
//

import Foundation

struct ServiceHandler {
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    private enum Endpoints {
        case fetchTodo
        case deleteTodo(todoIds: [String])
        case createTodo(todoName: String)

        func path()-> String {
            switch self {
            case .fetchTodo:
                return "todo"
            case .deleteTodo:
                return "todo"
            case .createTodo:
                return "todo"
            }
        }
        
        func httpMethod()-> String {
            switch self {
            case .fetchTodo:
                return HTTPMethod.get.rawValue
            case .deleteTodo:
                return HTTPMethod.delete.rawValue
            case .createTodo:
                return HTTPMethod.post.rawValue
            }
        }
        
        func url(forEnv env: Env) -> URL? {
            return URL(string: env.host + path())
        }
        
        func request(forEnv env: Env) -> URLRequest? {
            guard let url = self.url(forEnv: env) else {
                return nil
            }
            
            var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = self.httpMethod()

            switch self {
            case .fetchTodo:
                break
            case .deleteTodo(let todoIds):
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["ids": todoIds], options: [])
            case .createTodo(let todoName):
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["name": todoName], options: [])
            }
            
            return urlRequest
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
        
    private let env: Env
    private let session = URLSession(configuration: .default)
    
    init(env: Env = .debug) {
        self.env = env
    }
        
    func fetchTodos(completionHandler: @escaping (Result<[Todo], Error>) -> ()) {
        guard let urlRequest = Endpoints.fetchTodo.request(forEnv: self.env) else {
            assertionFailure("Could not form URL for fetchTodo")
            return
        }

        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil, let data = data else {
                    print("Error fetching todos: \(String(describing: error))")
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.success([]))
                    }
                    return
                }
                
                completionHandler(.success((try? JSONDecoder().decode([Todo].self, from: data)) ?? []))
            }
        }
        dataTask.resume()
    }
    
    func deleteTodo(with todoIds: [String], completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let urlRequest = Endpoints.deleteTodo(todoIds: todoIds).request(forEnv: self.env) else {
            assertionFailure("Could not form URL for deleteTodo")
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Error deleting todo: \(String(describing: error))")
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.success(()))
                    }
                    return
                }
                
                completionHandler(.success(()))
            }
        }
        dataTask.resume()
    }
    
    func createTodo(withName todoName: String, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        guard let urlRequest = Endpoints.createTodo(todoName: todoName).request(forEnv: self.env) else {
            assertionFailure("Could not form URL for deleteTodo")
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Error creating todo: \(String(describing: error))")
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.success(()))
                    }
                    return
                }
                
                completionHandler(.success(()))
            }
        }
        dataTask.resume()
    }
}

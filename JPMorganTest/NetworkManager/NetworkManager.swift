//
//  NetworkManager.swift
//  JPMorganTest
//
//  Created by Praveen Kumar on 27/04/23.
//

import Foundation

protocol URLSessionProtocol {
    
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func sessionDataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    
    func resume()
}

extension URLSession: URLSessionProtocol {
    
    func sessionDataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}


class NetworkManager {
    
    // MARK: - Constants
    
    static let instance = NetworkManager(session: URLSession(configuration: .default))
    private let baseURL = "https://swapi.dev/api/"
    private let session: URLSessionProtocol
    
    // MARK: - Type Alias
    
    typealias queryParameters = [String: String]
    typealias bodyParameters = [String: Any]
    typealias completeClosure<ResponseType :Decodable> = (ResponseType?, String?) -> Void
    
    // MARK: - init Method
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    // MARK: - Internal Methods
    
    func buildRequest(path: String,
                      httpMethod: HttpMethod,
                      param: queryParameters = [:],
                      bodyParam: bodyParameters = [:]) -> URLRequest {
        
        // build URL
        let urlString = baseURL + path
        
        // check URL components
        if var urlComponents = URLComponents(string: urlString) {
            
            urlComponents.queryItems = param.map { URLQueryItem(name: $0, value: $1) }
            
            // validate URL
            guard let url = urlComponents.url else {
                fatalError("wrong URL")
            }
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            if bodyParam.keys.count > 0 {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParam,
                                                           options: .prettyPrinted)
            }
            return request
        }
        fatalError("wrong URL")
    }
    
    func executeRequest<ResponseType :Decodable>(request: URLRequest,
                                                    responseType: ResponseType.Type,
                                                    completion: @escaping (ResponseType?, String?) -> Void) {
        
        // do the task
        let dataTask = session.sessionDataTask(with: request) {data, response, error in
            
            // check error
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, "HTTP Request Failed \(error.localizedDescription)")
                }
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                //decode the response
                let decoder = JSONDecoder()
                do {
                    let responseData = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseData, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, "Error")
                    }
                }
            }
            return
        }
        // task resume
        dataTask.resume()
    }
}


public enum HttpMethod: String, CaseIterable {
    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace
}

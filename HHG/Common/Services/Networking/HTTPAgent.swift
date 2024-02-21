//
//  HTTPAgent.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.07.21.
//

import Combine
import Foundation


// MARK: HTTPAgent
/// Agent to perform HTTP requests
struct HTTPAgent {
    /**
    Sends a DELETE request to the server and disregards the response.
    Used for deleting a run.
    - Parameters:
        - url: the URL to send the request to
    - Returns: A cancellable refering to the executed request
    */
    func delete(at url: URL) -> AnyCancellable {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { _ in })
    }
    
    /**
    Sends a GET request for the given URL to the server and tries to decode the response to the type T.
    Traverses the "data" object which contains the payload using `ResponseWrapper`.
    Dates are decoded as Unix timestamps.
    Used for requesting all runs.
    - Parameters:
        - url: the URL to send the GET request to
    - Returns: A publisher publishing the single response of type T
    */
    func getJSON<T: Decodable>(from url: URL, with arguments: [String : String]) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpBody = deconstructBody(from: arguments).data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func sendData(to url: URL, with arguments: [String : String]) -> Future<Bool, Never> {
        Future { promise in
            var request = URLRequest(url: url)
            request.httpBody = deconstructBody(from: arguments).data(using: .utf8)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if error != nil {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
            task.resume()
        }
    }
    
    /**
    Starts an UploadTask for the given URL, HTTP method, and payload serialized as JSON.
    Dates are encoded as Unix timestamps.
    Used for uploading run statistics and images.
    - Parameters:
        - payload: the encodable payload to send as JSON
        - url: the URL to send the payload to
        - httpMethod: the HTTP method to use for the request
    - Returns: A publisher publishing the HTTP response code upon success
    */
    func uploadJSON<I: Encodable>(_ payload: I, to url: URL, withMethod httpMethod: String) -> AnyPublisher<Int, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let data = try encoder.encode(payload)
            
            return uploadData(data, using: request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /**
    Starts an UploadTask for the given request and data.
    - Parameters:
        - payload: the data to be uploaded
        - request: the request to use
    - Returns: A publisher publishing the HTTP response code upon success
    */
    private func uploadData(_ payload: Data, using request: URLRequest) -> AnyPublisher<Int, Error> {
        Future<Int, Error> { promise in
            let task = URLSession.shared.uploadTask(with: request, from: payload) { _, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if (200...299).contains(statusCode) {
                        promise(.success(statusCode))
                    } else {
                        promise(.failure(HTTPError(integerLiteral: statusCode)))
                    }
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
    
    /**
    Creates a HTTP body for a dictionary of strings
    - Parameters:
        - data: the dictionary to be deconstructed into a String
    - Returns: A formatted String literal including the data from the input
    */
    private func deconstructBody(from data: [String : String]) -> String {
        data.reduce("{", { "\($0)\"\($1.key)\":\"\($1.value)\"," }).dropLast() + "}"
    }
}

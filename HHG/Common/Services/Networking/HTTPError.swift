//
//  HTTPError.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.07.21.
//

import Foundation

// MARK: - HTTPError
public enum HTTPError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case unprocessableRequest
    case unknown
}

// MARK: - ExpressibleByIntegerLiteral
extension HTTPError: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        switch value {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 404:
            self = .notFound
        case 422:
            self = .unprocessableRequest
        case 500:
            self = .serverError
        default:
            self = .unknown
        }
    }
}

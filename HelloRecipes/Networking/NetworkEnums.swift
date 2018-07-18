//
//  NetworkingConstants.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 7/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ResponseType<T> {
    case success(object: T)
    case failure(error: NetworkError)
}

enum NetworkError: Error {
    case noServerConnection
    case noDataReturned
    case unparsable
    case unauthorized
    case unknown
    case internalServerError
    case incorrectParameters
}

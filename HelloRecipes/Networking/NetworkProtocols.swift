//
//  NetworkLoader.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 7/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

protocol LoadableType {
    associatedtype T
    
    var urlRequest: URLRequest { get }
    var parser: (Data) throws -> T { get }
}

protocol NetworkLoader {
    func load<T: LoadableType>(resource: T, completion: @escaping (ResponseType<T.T>) -> ())
}

protocol NetworkRequestExecutor {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    
    func dataTask(with request: URLRequest) -> URLSessionDataTask
}

extension URLSession: NetworkRequestExecutor { }

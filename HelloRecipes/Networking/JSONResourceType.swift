//
//  JSONResourceType.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 7/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

struct JSONResrouceType<T: Decodable>: LoadableType {
    var urlRequest: URLRequest
    
    var parser: (Data) throws -> T = { data in
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    init(ingredients: [Ingredient], path: String, queries: [String: String] = [:], method: HTTPMethod = .get, body: Data? = nil, headers: [String: String]? = nil) {
        
        guard let baseUrl = URL(string: "https://api.edamam.com") else { fatalError("Coudn't get baseUrl") }
        guard let url = baseUrl.appendingPathComponent(path).withQueries(queries) else { fatalError("Coudnt create url from baseURL and componenets / queries. \(#function)") }
        
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
    }
    
    init(url: URL, method: HTTPMethod = .get, body: Data? = nil, headers: [String: String]? = nil) {
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
    }
    
}

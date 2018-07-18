//
//  ResourceType.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 7/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

struct ImageNetworkResource<T: UIImage>: LoadableType {
    var urlRequest: URLRequest
    
    var url: URL
    var parser: (Data) throws -> UIImage
    
    init(url: URL) {
        self.url = url
        self.urlRequest = URLRequest(url: url)
        parser = { data in
            if let image = UIImage(data: data) {
                return image
            }
            
            throw NetworkError.unparsable
        }
    }
}

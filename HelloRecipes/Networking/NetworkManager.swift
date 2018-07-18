//
//  NetworkManager.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 7/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class NetworkManager: NSObject, NetworkLoader {
    var requestExecutor: NetworkRequestExecutor?
    var data = [URLSessionTask: Data]()
    var errors = [URLSessionTask: NetworkError]()
    var loadCompletionHandlers = [URLSessionTask: () -> ()]()
    var connectivityLost = false
    
    init(requestExecutor: NetworkRequestExecutor? = nil) {
        super.init()
        
        if let requestExecutor = requestExecutor {
            self.requestExecutor = requestExecutor
        } else {
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true
            config.timeoutIntervalForRequest = 20
            config.urlCache?.memoryCapacity = 10*1024*1024
            config.urlCache?.diskCapacity = 50*1024*1024
            self.requestExecutor = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        }
        
    }
    
    /// Loads an object that conforms to the LodableType protocol.
    ///
    /// - Parameters:
    ///   - resource: The type that's being loaded. Could be either JSONResource type or ImageNetworkResource.
    ///   - completion: The return from the call back. Returns an enum with an associated type that's either an error the type that's being loaded (T)
    func load<T>(resource: T, completion: @escaping (ResponseType<T.T>) -> ()) where T : LoadableType {
        guard let task = requestExecutor?.dataTask(with: resource.urlRequest) else {
            fatalError("NetworkingManager doesn't work without a NetworkRequestExecutor")
        }
        
        loadCompletionHandlers[task] = {
            if let error = self.errors[task] {
                completion(.failure(error: error))
            }
            
            guard let data = self.data[task] else {
                completion(.failure(error: .noDataReturned))
                return
            }
            
            guard let object = try? resource.parser(data) else {
                completion(.failure(error: .unparsable))
                return
            }
            completion(.success(object: object))
        }
    }
    
    private func errorFromResponse(_ response: HTTPURLResponse) -> NetworkError? {
        switch response.statusCode {
        case 500:
            return .internalServerError
        case 442:
            return .incorrectParameters
        case 401:
            return .unauthorized
        case 200:
            return nil
        default:
            return .unknown
        }
    }
    
}

// MARK: - URLSessionDataDelegate
extension NetworkManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        if !connectivityLost {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .connectivityLost, object: self)
            }
            connectivityLost = true
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if var existiingData = self.data[dataTask] {
            existiingData.append(data)
            self.data[dataTask] = existiingData
        } else {
            self.data[dataTask] = data
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil && errors[task] == nil {
            errors[task] = .unknown
        }
        
        loadCompletionHandlers[task]?()
        
        errors.removeValue(forKey: task)
        data.removeValue(forKey: task)
        loadCompletionHandlers.removeValue(forKey: task)
    }
    
    
}















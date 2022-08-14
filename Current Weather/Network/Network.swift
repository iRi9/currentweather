//
//  Network.swift
//  Current Weather
//
//  Created by Giri Bahari on 11/08/22.
//

import Foundation

final class Network {
    func call<T: Decodable>(request: URLRequest, _ completion: @escaping(Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                if let data = data {
                    do {
                        let dataObject = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(dataObject))
                    } catch {
                        completion(.failure(error.localizedDescription as! Error))
                    }
                }
                return
            }

            if let data = data {
                do {
                    let dataObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(dataObject))
                } catch {
                    completion(.failure(error.localizedDescription as! Error))
                }
            }

        }
        task.resume()
    }
}

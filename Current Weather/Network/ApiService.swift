//
//  ApiService.swift
//  Current Weather
//
//  Created by Giri Bahari on 11/08/22.
//

import Foundation

final class ApiService {
    private let network: Network
    private let appid = ""
    init() {
        self.network = Network()
    }

    func getCurrentWeather(latitude: String, longitude: String, completion: @escaping(Result<Response, ErrorResponse>) -> Void) {
        let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(appid)")!
        var urlRequest = URLRequest(url: weatherUrl)
        urlRequest.httpMethod = "get"
        network.call(request: urlRequest) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as! ErrorResponse))
            }
        }
    }
}

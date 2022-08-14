//
//  ErrorResponse.swift
//  Current Weather
//
//  Created by Giri Bahari on 13/08/22.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Decodable, Error {
    let cod: Int?
    let message: String?
}

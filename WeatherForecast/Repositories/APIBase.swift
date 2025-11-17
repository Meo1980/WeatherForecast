//
//  APIBase.swift
//  DuBaoThoiTiet
//
//  Created by Tran Thi Yen Linh on 9/4/25.
//

import Foundation

struct KeyAnyValue {
  var key: String
  var value: Any
}

protocol APIBase {
  var path: String { get }
  var method: String { get }
  var headers: [String: String]? { get }
  var queryParams: [KeyAnyValue] { get }
  func body() throws -> Data?
}

extension APIBase {
  func makeURL(baseURL: String) throws -> URL {
    guard let url = URL(string: baseURL + path) else {
      throw APIError.invalidURL
    }

    guard var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      throw URLError(URLError.Code.badURL)
    }
    let queryItems = queryParams.map { (item) -> URLQueryItem in
      URLQueryItem(name: item.key, value: "\(item.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
    }
    urlComponent.queryItems = queryItems

    guard urlComponent.url != nil else {
      throw APIError.invalidURL
    }

    return urlComponent.url!
  }

  func makeRequest(baseURL: String) throws -> URLRequest {
    let url = try makeURL(baseURL: baseURL)
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    request.httpBody = try body()
    return request
  }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
  static let success = 200 ..< 300
}

enum APIError: Swift.Error, Equatable {
  case invalidURL
  case httpCode(HTTPCode)
  case unexpectedResponse
  case invalidData
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL: return "Invalid URL"
    case let .httpCode(code): return "Unexpected HTTP code: \(code)"
    case .unexpectedResponse: return "Unexpected response from the server"
    case .invalidData: return "Wrong return data format"
    }
  }
}



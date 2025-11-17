//
//  RepositoryBase.swift
//  DuBaoThoiTiet
//
//  Created by Tran Thi Yen Linh on 10/4/25.
//

import Combine
import Foundation

protocol RepositoryBase {
  var session: URLSession { get }
  var baseURL: String { get }
}

extension RepositoryBase {
  func loadData<Value: Decodable>(
    api: APIBase,
    httpCodes: HTTPCodes = .success
  ) async throws -> Value {
    let request = try api.makeRequest(baseURL: baseURL)
    let (data, response) = try await session.data(for: request)
    guard let code = (response as? HTTPURLResponse)?.statusCode else {
      throw APIError.unexpectedResponse
    }
    guard httpCodes.contains(code) else {
      throw APIError.httpCode(code)
    }
    do {
      return try JSONDecoder().decode(Value.self, from: data)
    } catch {
      throw APIError.unexpectedResponse
    }
  }

  func download(api: APIBase) async throws -> Data {
    let url = try api.makeURL(baseURL: baseURL)
    let (localURL, _) = try await session.download(from: url)
    do {
      return try Data(contentsOf: localURL)
    } catch {
      throw APIError.unexpectedResponse
    }
  }
}

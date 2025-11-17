//
//  MockNetwork.swift
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 11/4/25.
//
import Foundation
@testable import WeatherForecast

// MARK: - MockRequest

final class MockRequest: URLProtocol {
  override class func canInit(with request: URLRequest) -> Bool {
    return response(for: request) != nil
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    return false
  }

  override func startLoading() {
    if let mock = MockRequest.response(for: request),
       let url = request.url,
       let response = mock.customResponse ??
        HTTPURLResponse(url: url,
                        statusCode: mock.httpCode,
                        httpVersion: "HTTP/1.1",
                        headerFields: mock.headers) {
      DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
        guard let self else { return }
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        switch mock.result {
        case let .success(data):
          self.client?.urlProtocol(self, didLoad: data)
          self.client?.urlProtocolDidFinishLoading(self)
        case let .failure(error):
          self.client?.urlProtocol(self, didFailWithError: error)
        }
      }
    }
  }

  override func stopLoading() { }
}

// MARK: - MockRequest - MockResponse

extension MockRequest {
  struct MockResponse {
    let url: URL
    let result: Result<Data, Swift.Error>
    let httpCode: HTTPCode
    let headers: [String: String]
    let loadingTime: TimeInterval
    let customResponse: URLResponse?
  }
}

extension MockRequest {
  private final class MocksContainer: @unchecked Sendable {
    var responses: [MockResponse] = []
  }
  static private let container = MocksContainer()
  static private let lock = NSLock()

  static func add(response: MockResponse) {
    lock.withLock {
      container.responses.append(response)
    }
  }

  static func removeAllResponses() {
    lock.withLock {
      container.responses.removeAll()
    }
  }

  static private func response(for request: URLRequest) -> MockResponse? {
    return lock.withLock {
      container.responses.first { $0.url == request.url }
    }
  }
}

extension MockRequest.MockResponse {
  init<T>(api: APIBase,
          baseURL: String,
          result: Result<T, Swift.Error>,
          httpCode: HTTPCode = 200,
          headers: [String: String] = ["Content-Type": "application/json"],
          loadingTime: TimeInterval = 0.1
  ) throws where T: Encodable {
    let url = try api.makeURL(baseURL: baseURL)
    self.url = url
    switch result {
    case let .success(value):
      self.result = .success(try JSONEncoder().encode(value))
    case let .failure(error):
      self.result = .failure(error)
    }
    self.httpCode = httpCode
    self.headers = headers
    self.loadingTime = loadingTime
    customResponse = nil
  }

  init(api: APIBase, baseURL: String, customResponse: URLResponse) throws {
    let url = try api.makeURL(baseURL: baseURL)
    self.url = url
    result = .success(Data())
    httpCode = 200
    headers = [String: String]()
    loadingTime = 0
    self.customResponse = customResponse
  }

  init(api: APIBase, baseURL: String, dataResult: Result<Data, Swift.Error>) throws {
    let url = try api.makeURL(baseURL: baseURL)
    self.url = url
    self.result = dataResult
    httpCode = 200
    headers = [String: String]()
    loadingTime = 0
    customResponse = nil
  }
}

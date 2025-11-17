//
//  RepositoryBaseTest.swift
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 11/4/25.
//

import Testing
import UIKit
@testable import WeatherForecast

@Suite(.serialized) final class RepositoryBaseTest {
  private let sut = MockRepositoryBase()
  private typealias API = MockRepositoryBase.API

  deinit {
    MockRequest.removeAllResponses()
  }

  @Test func loadSuccess() async throws {
    let data = MockRepositoryBase.ValidData()
    try mockRequest(.test, result: .success(data))
    let result = try await sut.load(.test)
    #expect(result == data)
  }

  @Test func loadParseError() async throws {
    let data = MockRepositoryBase.InvalidData()
    try mockRequest(.test, result: .success(data))
    await #expect(throws: APIError.unexpectedResponse) {
      try await sut.load(.test)
    }
  }

  @Test func loadHttpCodeFailure() async throws {
    let data = MockRepositoryBase.ValidData()
    try mockRequest(.test, result: .success(data), httpCode: 500)
    await #expect(throws: APIError.httpCode(500)) {
      try await sut.load(.test)
    }
  }

  @Test func loadNetworkingError() async throws {
    let errorRef = NSError.test
    try mockRequest(.test, result: Result<MockRepositoryBase.ValidData, Error>.failure(errorRef))
    do {
      _ = try await sut.load(.test)
      Issue.record("Above should throw")
    } catch {
      let nsError = error as NSError
      #expect(nsError.domain == errorRef.domain)
      #expect(nsError.code == errorRef.code)
    }
  }

  @Test func loadRequestURLError() async {
    await #expect(throws: APIError.invalidURL) {
      try await sut.load(.urlError)
    }
  }

  @Test func loadRequestBodyError() async {
    await #expect(throws: MockRepositoryBase.APIError.fail) {
      try await sut.load(.bodyError)
    }
  }

  @Test func loadLoadableError() async {
    await #expect(throws: APIError.invalidURL) {
      try await sut.load(.urlError)
    }
  }

  @Test func loadNoHttpCodeError() async throws {
    let response = URLResponse(url: URL(fileURLWithPath: ""),
                               mimeType: "example", expectedContentLength: 0, textEncodingName: nil)
    let mock = try MockRequest.MockResponse(api: API.test, baseURL: sut.baseURL, customResponse: response)
    MockRequest.add(response: mock)
    await #expect(throws: APIError.unexpectedResponse) {
      try await sut.load(.test)
    }
  }

  @Test func downloadSuccess() async throws {
    let testString = "This is test string"
    let testData = try #require(testString.data(using: .utf8))

    let mock = try MockRequest.MockResponse(api: API.test, baseURL: sut.baseURL, dataResult: .success(testData))
    MockRequest.add(response: mock)
    let result = try await sut.download(api: API.test)

    let resultString = String(data: result, encoding: .utf8)
    #expect(resultString == testString)
  }

  @Test func downloadFailure() async throws {
    let errorRef = NSError.test
    try mockRequest(.test, result: Result<MockRepositoryBase.ValidData, Error>.failure(errorRef))

    do {
      _ = try await sut.download(api: API.test)
      Issue.record("Above should throw")
    } catch {
      let nsError = error as NSError
      #expect(nsError.domain == errorRef.domain)
      #expect(nsError.code == errorRef.code)
    }
  }

  // MARK: - Helper

  private func mockRequest<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                       httpCode: HTTPCode = 200) throws where T: Encodable {
    let mock = try MockRequest.MockResponse(api: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
    MockRequest.add(response: mock)
  }
}

private extension MockRepositoryBase {
  func load(_ api: API) async throws -> ValidData {
    try await loadData(api: api)
  }
}

// MARK: - Test Data

private extension MockRepositoryBase {
  enum API: APIBase {

    case test
    case urlError
    case bodyError

    var path: String {
      if self == .urlError {
        return "\\"
      }
      return "/test/path"
    }
    var method: String { "POST" }
    var headers: [String: String]? { nil }
    var queryParams: [KeyAnyValue] { [] }
    func body() throws -> Data? {
      if self == .bodyError { throw APIError.fail }
      return nil
    }
  }

  enum APIError: Swift.Error, LocalizedError {
    case fail
    var errorDescription: String? { "fail" }
  }

  struct ValidData: Codable, Equatable {
    let string: String
    let integer: Int

    init() {
      string = "valid"
      integer = 200
    }
  }

  struct InvalidData: Codable, Equatable {
    let string: String

    init() {
      string = "invalid"
    }
  }
}

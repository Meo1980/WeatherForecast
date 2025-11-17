//
//  Extensions.swift
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 11/4/25.
//

import Foundation

extension NSError {
  static var test: NSError {
    return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
  }
}

extension URLSession {
  static var mockedResponse: URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockRequest.self]
    configuration.timeoutIntervalForRequest = 1
    configuration.timeoutIntervalForResource = 1
    return URLSession(configuration: configuration)
  }
}

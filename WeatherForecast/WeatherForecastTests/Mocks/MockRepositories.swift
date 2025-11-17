//
//  MockRepositories.swift
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 11/4/25.
//
import Foundation
@testable import WeatherForecast

class MockRepositoryBase: RepositoryBase {
  let session: URLSession = .mockedResponse
  let baseURL = "https://test.com"
}

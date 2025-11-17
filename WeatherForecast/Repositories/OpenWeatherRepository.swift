//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 14/4/25.
//

import Foundation
import CoreLocation

protocol OpenWeatherRepositoryProtocol: RepositoryBase {
  var apiKey: String { get }

  func getWeather(location: CLLocation) -> Void
  func getWeather(cityName: String) -> Void
  func getWeather(cityID: String) -> Void
  func getWeather(zipCode: String) -> Void
}

struct OpenWeatherRepository: OpenWeatherRepositoryProtocol {
  let session: URLSession
  let baseURL: String
  let apiKey: String

  init(session: URLSession, apiKey: String) {
    self.session = session
    self.baseURL = "https://api.openweathermap.org/"
    self.apiKey = apiKey
  }

  func getWeather(location: CLLocation) -> Void {}
  func getWeather(cityName: String) -> Void {}
  func getWeather(cityID: String) -> Void {}
  func getWeather(zipCode: String) -> Void {}
}

extension OpenWeatherRepository {
  enum API {
    case location(long: Double, lat: Double, key: String, mode: MODE?, units: UNITS?, lang: LANG?)
    case cityName(name: String, countryCode: String?, stateCode: String?, key: String, mode: MODE?, units: UNITS?, lang: LANG?)
    case cityID(id: String, key: String, mode: MODE?, units: UNITS?, lang: LANG?)
    case zipCode(zip: String, countryCode: String?, key: String, mode: MODE?, units: UNITS?, lang: LANG?)
  }
}

extension OpenWeatherRepository.API: APIBase {
  var path: String {
    "data/2.5/weather"
  }
  
  var method: String {
    "GET"
  }
  
  var headers: [String : String]? {
    ["Accept": "application/json"]
  }
  
  var queryParams: [KeyAnyValue] {
    switch self {
    case .location(let long, let lat, let key, let mode, let units, let lang):
      var params: [KeyAnyValue] = [
        KeyAnyValue(key: "lat", value: lat),
        KeyAnyValue(key: "lon", value: long),
        KeyAnyValue(key: "appid", value: key),
      ]
      if let mode = mode {
        params.append(KeyAnyValue(key: "mode", value: mode.rawValue))
      }
      if let units = units {
        params.append(KeyAnyValue(key: "units", value: units.rawValue))
      }
      if let lang = lang {
        params.append(KeyAnyValue(key: "lang", value: lang.rawValue))
      }
      return params

    case .cityName(let name, let countryCode, let stateCode, let key, let mode, let units, let lang):
      var city = name
      if let stateCode = stateCode {
        city += ",\(stateCode)"
      }
      if let countryCode = countryCode {
        city += ",\(countryCode)"
      }
      var params: [KeyAnyValue] = [
        KeyAnyValue(key: "q", value: city),
        KeyAnyValue(key: "appid", value: key),
      ]
      if let mode = mode {
        params.append(KeyAnyValue(key: "mode", value: mode.rawValue))
      }
      if let units = units {
        params.append(KeyAnyValue(key: "units", value: units.rawValue))
      }
      if let lang = lang {
        params.append(KeyAnyValue(key: "lang", value: lang.rawValue))
      }
      return params

    case .cityID(let id, let key, let mode, let units, let lang):
      var params: [KeyAnyValue] = [
        KeyAnyValue(key: "id", value: id),
        KeyAnyValue(key: "appid", value: key),
      ]
      if let mode = mode {
        params.append(KeyAnyValue(key: "mode", value: mode.rawValue))
      }
      if let units = units {
        params.append(KeyAnyValue(key: "units", value: units.rawValue))
      }
      if let lang = lang {
        params.append(KeyAnyValue(key: "lang", value: lang.rawValue))
      }
      return params

    case .zipCode(let zip, let countryCode, let key, let mode, let units, let lang):
      var zipCode = zip
      if let countryCode = countryCode {
        zipCode += ",\(countryCode)"
      }
      var params: [KeyAnyValue] = [
        KeyAnyValue(key: "zip", value: zipCode),
        KeyAnyValue(key: "appid", value: key),
      ]
      if let mode = mode {
        params.append(KeyAnyValue(key: "mode", value: mode.rawValue))
      }
      if let units = units {
        params.append(KeyAnyValue(key: "units", value: units.rawValue))
      }
      if let lang = lang {
        params.append(KeyAnyValue(key: "lang", value: lang.rawValue))
      }
      return params
    }
  }
  
  func body() throws -> Data? {
    nil
  }
}

extension OpenWeatherRepository {
  enum MODE: String {
    case xml
    case html
  }
}

extension OpenWeatherRepository {
  enum UNITS: String {
    case standard
    case metric
    case imperial
  }
}

extension OpenWeatherRepository {
}

extension OpenWeatherRepository {
  enum LANG: String {
      case Albanian = "sq"
    case Afrikaans = "af"
    case Arabic = "ar"
    case Azerbaijani = "az"
    case Basque = "eu"
    case Belarusian = "be"
    case Bulgarian = "bg"
    case Catalan = "ca"
    case ChineseSimplified = "zh_CN"
    case ChineseTraditional = "zh_TW"
    case Croatian = "hr"
    case Czech = "cs"
    case Danish = "da"
    case Dutch = "nl"
    case English = "en"
    case Finnish = "fi"
    case French = "fr"
    case Galician = "gl"
    case German = "de"
    case Greek = "el"
    case Hebrew = "he"
    case Hindi = "hi"
    case Hungarian = "hu"
    case Icelandic = "is"
    case Indonesian = "id"
    case Italian = "it"
    case Japanese = "ja"
    case Korean = "ko"
    case Kurmanji = "ku"
    case Latvian = "la"
    case Lithuanian = "lt"
    case Macedonian = "mk"
    case Norwegian = "no"
    case Persian = "fa"
    case Polish = "pl"
    case Portuguese = "pt"
    case PortuguêsBrasil = "pt_br"
    case Romanian = "ro"
    case Russian = "ru"
    case Serbian = "sr"
    case Slovak = "sk"
    case Slovenian = "sl"
    case Spanish = "es"
    case Swedish = "sv"
    case Thai = "th"
    case Turkish = "tr"
    case Ukrainian = "uk"
    case Vietnamese = "vi"
    case Zulu = "zu"
  }
}

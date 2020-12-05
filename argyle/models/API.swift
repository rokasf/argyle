//
//  APIService.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import Foundation

protocol API {
    func search(text: String, limit: Int, offset: Int, completion: @escaping APIResultHandler)
    func load(url: URL, completion: @escaping APIResultHandler)
}

typealias APIResultHandler = (Result<Response, APIServiceError>) -> Void

enum APIServiceError: Error {
    case serverError
    case invalidRequest
    case invalidResponse
    case noData
}

class APIService: API {
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.argyle.io"
        urlComponents.path = "/link/v1/link-items"

        return urlComponents
    }

    private let urlSession = URLSession.shared

    func search(text: String,
                limit: Int = 15,
                offset: Int = 0,
                completion: @escaping APIResultHandler) {

        var urlComps = urlComponents
        urlComps.queryItems = [URLQueryItem(name: "limit", value: String(limit)),
                               URLQueryItem(name: "offset", value: String(offset)),
                               URLQueryItem(name: "search", value: text)]

        guard let url = urlComps.url else {
            completion(.failure(.invalidRequest))
            return
        }

        load(url: url, completion: completion)
    }

    func load(url: URL, completion: @escaping APIResultHandler) {
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }.resume()
    }
}

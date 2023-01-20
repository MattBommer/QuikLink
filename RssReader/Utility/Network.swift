//
//  Networking.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

typealias HeaderValue = String
typealias HttpHeaderField = String
typealias HttpHeaders = [HttpHeaderField: HeaderValue]

enum ResponseError: Error {
    case unknownStatus
}

enum AuthTokenType {
    case access
    case refresh
    case none
}

public enum Response<T>: Decodable where T: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    case success(T)
    case failed(String)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        
        switch status.lowercased() {
        case "success":
            let data = try container.decode(T.self, forKey: .data)
            self = .success(data)
        case "failed":
            let message = try container.decode(String.self, forKey: .message)
            self = .failed(message)
        default:
            throw DecodingError.dataCorruptedError(forKey: .status, in: container, debugDescription: "Invalid status type")
        }
    }
}

public enum HTTPMethod: String {
    case delete
    case get
    case patch
    case post
    case put
}

public struct EmptyBody: Codable {}

struct RequestInfo<T> where T: Codable {
    var path: String
    var httpMethod: HTTPMethod
    var headers: HttpHeaders?
    var body: T?
    
    init(path: String, httpMethod: HTTPMethod, headers: HttpHeaders? = nil, body: T? = nil) {
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.body = body
    }
}

public class Network {
    
    static let shared: Network = Network()
    
    private let encoder: JSONEncoder
    
    private let decoder: JSONDecoder
    
    private let baseURL: URL?
    
    private init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        baseURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "HOST_URL") as! String)
    }
    
    func fetch<T>(request: URLRequest) async throws -> Response<T> {
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        let httpResponse = response as! HTTPURLResponse
        
        switch httpResponse.statusCode {
        case 200...399:
            print("All is well")
        case 400...499:
            print("Client error")
        case 500...599:
            print("Server Error")
        default:
            print("Unknown Error")
        }
        
        let decoded = try decoder.decode(Response<T>.self, from: data)
        return decoded
    }
    
    func buildRequest<T>(from requestInfo: RequestInfo<T>, authToken: AuthTokenType = .none) -> URLRequest? {
        guard let url = URL(string: requestInfo.path, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = requestInfo.httpMethod.rawValue.capitalized
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        switch authToken {
        case .access where JsonWebTokenStore.shared.accessToken != nil:
            request.setValue("bearer \(JsonWebTokenStore.shared.accessToken!.string)", forHTTPHeaderField: "authorization")
        case .refresh where JsonWebTokenStore.shared.refreshToken != nil:
            request.setValue("bearer \(JsonWebTokenStore.shared.refreshToken!.string)", forHTTPHeaderField: "authorization")
        default:
            break
        }
        
        if let headers = requestInfo.headers {
            headers.forEach { (field: HttpHeaderField, value: HeaderValue) in
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        guard let body = requestInfo.body else { return request }
        do {
            let bodyData = try encoder.encode(body)
            request.httpBody = bodyData
        } catch {
            print(error)
        }
        
        return request
    }
}

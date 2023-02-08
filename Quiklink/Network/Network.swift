//
//  Networking.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

public class Network {
    
    static let shared: Network = Network()
    
    weak var authenticationDelegate: AuthViewModel?
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
        
    private let baseURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "HOST_URL") as! String)
    
    private init() {}
    
    func fetch<T>(requestInfo: RequestInfo) async -> Result<T, ResponseError> where T: Decodable {
        guard let urlRequest = buildRequest(from: requestInfo) else { fatalError("Unable to build endpoint url for path \(requestInfo.path)") }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else { fatalError("Response is not HTTP, something is wrong with backend")}
            
            if let accessToken = httpResponse.value(forHTTPHeaderField: "access-token"),
               let refreshToken = httpResponse.value(forHTTPHeaderField: "refresh-token") {
                JsonWebTokenStore.shared.setTokens(JWTTokens(refresh: refreshToken, access: accessToken))
            }
            
            switch httpResponse.statusCode {
            case 401:
                await authenticationDelegate?.logOut()
                fallthrough
            case 200...499:
                let decoded = try decoder.decode(Response<T>.self, from: data)
                return .success(decoded.data)
            case 500...599:
                return .failure(ResponseError.serverError)
            default:
                return .failure(ResponseError.unknownError)
            }
            
        } catch DecodingError.keyNotFound(_, let context) {
            return .failure(ResponseError.clientError(context.debugDescription))
        } catch {
            print(error)
            // URL session can't connect, tell user they aren't connect to internet
            return .failure(.connectionError)
        }
    }
    
    private func buildRequest(from requestInfo: RequestInfo) -> URLRequest? {
        guard let url = URL(string: requestInfo.path, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = requestInfo.httpMethod.rawValue.capitalized
        request.httpBody = requestInfo.body
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if requestInfo.needsAuthorizationToken, let token = JsonWebTokenStore.shared.fetchValidToken() {
            request.setValue("bearer \(token.string)", forHTTPHeaderField: "authorization")
        }
        
        if let headers = requestInfo.headers {
            headers.forEach { (field: HttpHeaderField, value: HeaderValue) in
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        return request
    }
}

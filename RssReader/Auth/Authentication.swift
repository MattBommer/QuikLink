//
//  Authentication.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Combine
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var status: AuthenticationStatus
    
    enum AuthenticationStatus {
        case authenticated
        case unauthenticated
        case notSet
    }
    
    init() {
        status = .notSet
        self.refreshAuthenticationStatus()
    }
    
    func refreshAuthenticationStatus() {
        if let refreshToken = JsonWebTokenStore.shared.refreshToken, !refreshToken.expired  {
            status = .authenticated
        } else {
            status = .unauthenticated
        }
    }
    
    func login(user: User) async throws {
        let requestInfo = RequestInfo(path: "login", httpMethod: .post, headers: nil, body: user)
        guard let urlRequest = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let response: Response<JWTTokens> = try await Network.shared.fetch(request: urlRequest)
        
        switch response {
        case .success(let tokens):
            try JsonWebTokenStore.shared.setTokens(tokens)
            await MainActor.run(body: { status = .authenticated })
        default:
            await MainActor.run(body: { status = .unauthenticated })
        }
    }
    
    func signUp(user: User) async throws -> String? {
        let requestInfo = RequestInfo(path: "signup", httpMethod: .post, headers: nil, body: user)
        guard let urlRequest = Network.shared.buildRequest(from: requestInfo) else { return nil }

        let response: Response<String> = try await Network.shared.fetch(request: urlRequest)
        
        var result: String
        switch response {
        case .success(let message):
            result = message
        case .failed(let message):
            result = message
        }
        
        return result
    }
}

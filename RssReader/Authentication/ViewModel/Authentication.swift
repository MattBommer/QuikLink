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
        var authStatus: AuthenticationStatus = .unauthenticated
        defer { status = authStatus }
        
        guard let refreshToken = JsonWebTokenStore.shared.refreshToken else { return }
        
        if refreshToken.expired {
            JsonWebTokenStore.shared.deleteStaleTokens()
        } else {
            authStatus = .authenticated
        }
    }
    
    func login(user: User) async throws {
        let requestInfo = RequestInfo(path: "login", httpMethod: .post, headers: nil, body: user)
        guard let urlRequest = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let response: Response<JWTTokens> = try await Network.shared.fetch(request: urlRequest)
        
        switch response {
        case .success(let tokens):
            try JsonWebTokenStore.shared.setTokens(tokens)
        default:
            break
        }
        
        await MainActor.run(body: { refreshAuthenticationStatus() })
    }
    
    func signUp(user: User) async throws -> String? {
        let requestInfo = RequestInfo(path: "signup", httpMethod: .post, headers: nil, body: user)
        guard let urlRequest = Network.shared.buildRequest(from: requestInfo) else { return nil }

        let response: Response<SignUpMessage> = try await Network.shared.fetch(request: urlRequest)
        
        var result: String
        switch response {
        case .success(let signUpMessage):
            result = signUpMessage.message
        case .failed(let message):
            result = message
        }
        
        return result
    }
}

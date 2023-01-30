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
        let jwtStore = JsonWebTokenStore.shared
        guard let _ = jwtStore.accessToken, let refreshToken = jwtStore.refreshToken else { status = .unauthenticated; return; }
        status = refreshToken.expired ? .unauthenticated : .authenticated
    }
    
    func login(user: User) async throws {
        let requestInfo = RequestInfo(path: "login", httpMethod: .post, body: user)
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
        let requestInfo = RequestInfo(path: "signup", httpMethod: .post, body: user)
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
    
    func fetchFreshTokens() async throws {
        let requestInfo = RequestInfo(path: "refresh", httpMethod: .get)
        guard let urlRequest = Network.shared.buildRequest(from: requestInfo, authToken: .refresh) else { return }
        
        let response: Response<JWTTokens> = try await Network.shared.fetch(request: urlRequest)
        
        switch response {
        case .success(let tokens):
            try JsonWebTokenStore.shared.setTokens(tokens)
        default:
            break
        }
        
        await MainActor.run(body: { refreshAuthenticationStatus() })
    }
    
    func logOut() {
        JsonWebTokenStore.shared.deleteTokens()
        status = .unauthenticated
    }
}

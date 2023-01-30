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
        Network.shared.authenticationDelegate = self
    }
    
    func refreshAuthenticationStatus() {
        let jwtStore = JsonWebTokenStore.shared
        guard let _ = jwtStore.accessToken, let refreshToken = jwtStore.refreshToken else { status = .unauthenticated; return; }
        status = refreshToken.expired ? .unauthenticated : .authenticated
    }
    
    func login(user: User) async throws {
        let requestInfo = RequestInfo(path: "login", httpMethod: .post, body: user, needsAuthorizationToken: false)
        guard let urlRequest = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let _: Response<EmptyBody> = try await Network.shared.fetch(request: urlRequest)
        
        await MainActor.run(body: { refreshAuthenticationStatus() })
    }
    
    func signUp(user: User) async throws -> String? {
        let requestInfo = RequestInfo(path: "signup", httpMethod: .post, body: user, needsAuthorizationToken: false)
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
    
    func logOut() {
        JsonWebTokenStore.shared.deleteTokens()
        status = .unauthenticated
    }
}

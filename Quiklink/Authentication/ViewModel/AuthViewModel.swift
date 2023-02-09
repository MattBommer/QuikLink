//
//  AuthViewModel.swift
//  Quiklink
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
        let _:EmptyBody = try await Network.shared.fetch(requestInfo: requestInfo).get()
        refreshAuthenticationStatus()
    }
    
    func signUp(user: User) async throws -> SignUpMessage {
        let requestInfo = RequestInfo(path: "signup", httpMethod: .post, body: user, needsAuthorizationToken: false)
        return try await Network.shared.fetch(requestInfo: requestInfo).get()
    }
    
    func logOut() {
        JsonWebTokenStore.shared.deleteTokens()
        status = .unauthenticated
    }
}

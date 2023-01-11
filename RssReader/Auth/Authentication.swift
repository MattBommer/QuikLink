//
//  Authentication.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

class AuthViewModel {
    
    init() {}
    
    func signUp(_ user: User) async -> ResponseStatus {
        guard let url = URL(string: "http://localhost:3000/signup") else { fatalError("sign up url is incorrect")}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        var response: Response<String>
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(user)
            response = try await Network.shared.fetch(request: urlRequest)
            return response.message
        } catch {
            return .failed(message: error.localizedDescription)
        }
    }
    
    func login(_ user: User) async -> ResponseStatus {
        guard let url = URL(string: "http://localhost:3000/login") else { fatalError("login url is incorrect")}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        var response: Response<JWTToken>
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(user)
            response = try await Network.shared.fetch(request: urlRequest)
            
            switch response.status {
            case .success:
                Keychain
            case .failed:
                break
            }
            
            return response.status
        } catch {
            return .failed(message: error.localizedDescription)
        }
    }
}

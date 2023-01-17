//
//  JSONWebToken.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import JWTDecode
import KeychainAccess

struct JWTTokens: Codable {
    var refresh: String
    var access: String
}

enum TokenKeychainError: Error {
    case noTokenStored
    case tokenCorrupted
    case unhandledError(status: OSStatus)
}

typealias JWTString = String?



struct RawJWTString {
    var token: String
}


class JsonWebTokenStore {
    
    static let shared: JsonWebTokenStore = JsonWebTokenStore()
    
    private let keychain = Keychain(service: "json.web.token.service")
    
    var accessToken: JWT? {
        get {
            retrieveToken(key: "accessToken")
        }
    }
    
    var refreshToken: JWT? {
        get {
           retrieveToken(key: "refreshToken")
        }
    }
    
    private init() {}
    
    internal func setTokens(_ tokens: JWTTokens?) throws {
        guard let tokens = tokens else { return }
        
        do {
            try keychain.set(tokens.access, key: "accessToken")
            try keychain.set(tokens.refresh, key: "refreshToken")
        } catch {
            print(error)
        }

    }
    
    internal func deleteStaleTokens() {
        try? keychain.removeAll()
    }
    
    private func retrieveToken(key: String) -> JWT? {
        guard let rawToken = try? keychain.get(key) else { return nil }
        return try? decode(jwt: rawToken)
    }
}
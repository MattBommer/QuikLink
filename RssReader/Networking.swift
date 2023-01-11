//
//  Networking.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

enum ResponseStatus: Decodable {
    case success(message: String?)
    case failed(message: String?)
}


//TODO: Make a custom json decoder so the message is put in the sta
struct Response<T>: Decodable where T: Decodable {
    var status: ResponseStatus
    var data: T?
}

public class Network {
    
    static let shared: Network = Network()
    
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func fetch<T>(request: URLRequest) async throws -> Response<T> {
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let decoded = try decoder.decode(Response<T>.self, from: data)
        return decoded
    }
}

//
//  Response.swift
//  Quiklink
//
//  Created by Matt Bommer on 2/7/23.
//

import Foundation


enum ResponseError: LocalizedError {
    case connectionError
    case clientError(String)
    case serverError
    case unknownError
        
    var errorDescription: String? {
        switch self {
        case .connectionError:
            return "Unable to connect to the internet. Check device settings to make sure you have internet access."
        case .clientError(let message):
            return message
        case .serverError:
            return "Beep Boop Bop, their's an issue on our end 🤖. Try again later."
        case .unknownError:
            return "Uh well this is embarrassing. We have no idea why this is happening 🙃."
        }
    }
}

struct Response<T>: Decodable where T: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    var data: T
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        
        switch status.lowercased() {
        case "success":
            data = try container.decode(T.self, forKey: .data)
        case "failed":
            let message = try container.decode(String.self, forKey: .message)
            throw DecodingError.keyNotFound(CodingKeys.data, .init(codingPath: [CodingKeys.data], debugDescription: message))
        default:
            throw DecodingError.dataCorruptedError(forKey: .status, in: container, debugDescription: "Invalid status type")
        }
    }
}

/// Namespace for endpoints that don't recieve data in the reponse body.
public struct EmptyBody: Codable {}

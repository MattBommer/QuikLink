//
//  URL+Extension.swift
//  RssReader
//
//  Created by Matt Bommer on 1/20/23.
//

import Foundation

extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}

//
//  Response.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import Foundation

struct Response: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Item]?
}

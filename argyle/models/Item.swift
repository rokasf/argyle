//
//  Item.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import Foundation

struct Item: Decodable {
    let id: String
    let name: String?
    let loginUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id, name
        case loginUrl = "login_url"
    }
}

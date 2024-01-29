//
//  SettingsModels.swift
//  Spotify
//
//  Created by 정우찬 on 2024/01/29.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}

//
//  AuthResponse.swift
//  Spotify
//
//  Created by Woochan Jeong on 2024/01/28.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

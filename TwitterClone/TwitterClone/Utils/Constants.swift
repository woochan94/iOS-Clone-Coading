//
//  Constants.swift
//  TwitterClone
//
//  Created by 정우찬 on 2024/02/03.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let REF_TWEETS = DB_REF.child("tweets")

//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by 정우찬 on 2024/02/21.
//

import Foundation

struct ActionSheetViewModel {
    
    // MARK: - Properties
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unFollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}


enum ActionSheetOptions {
    case follow(User)
    case unFollow(User)
    case report
    case delete
    
    var descirption: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.userName)"
        case .unFollow(let user):
            return "UnFollow @\(user.userName)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
}

//
//  ConversationController.swift
//  TwitterClone
//
//  Created by 정우찬 on 2024/01/30.
//

import UIKit

class ConversationController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Messages"
    }

}

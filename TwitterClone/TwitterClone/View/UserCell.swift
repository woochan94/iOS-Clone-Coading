//
//  UserCell.swift
//  TwitterClone
//
//  Created by Woochan Jeong on 2024/02/07.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    func configure() {
        guard let user = user else { return }
        
        userNameLabel.text = user.userName
        fullNameLabel.text = user.fullName
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }

}

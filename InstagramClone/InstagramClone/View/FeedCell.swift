//
//  FeedCell.swift
//  InstagramClone
//
//  Created by 정우찬 on 2024/03/17.
//

import SnapKit
import UIKit

class FeedCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemPink
        imageView.layer.cornerRadius = 40 / 2
        return imageView
    }()
    
    private lazy var userNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("test", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "1 like"
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Some test caption for me"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(12)
            $0.width.height.equalTo(40)
        }
        
        addSubview(userNameButton)
        userNameButton.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(8)
            $0.centerY.equalTo(profileImageView)
        }
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(snp.width).multipliedBy(1)
        }
        
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
        
        addSubview(likesLabel)
        likesLabel.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(-4)
            $0.left.equalToSuperview().offset(8)
        }
        
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(likesLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(8)
        }
        
        addSubview(postTimeLabel)
        postTimeLabel.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(8)
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapUserName() {
        print("touch")
    }
}

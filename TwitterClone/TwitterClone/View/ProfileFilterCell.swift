//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Woochan Jeong on 2024/02/06.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: ProfileFilterOptions! {
        didSet {
            titlelabel.text = option.description
        }
    }
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "test"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titlelabel.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 14)
            titlelabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(titlelabel)
        titlelabel.center(inView: self)
    }
}

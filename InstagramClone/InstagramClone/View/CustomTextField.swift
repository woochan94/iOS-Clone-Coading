//
//  CustomTextField.swift
//  InstagramClone
//
//  Created by 정우찬 on 2024/03/24.
//

import SnapKit
import UIKit

class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(50)
        }
        leftView = spacer
        leftViewMode = .always
        
        autocapitalizationType = .none
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        snp.makeConstraints {
            $0.height.equalTo(50)
        }
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

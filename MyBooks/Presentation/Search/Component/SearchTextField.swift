//
//  SearchTextField.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit

final class SearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
        keyboardType = .default
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        placeholder = "텍스트를 입력해 주세요"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

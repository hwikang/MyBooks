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
        self.borderStyle = .roundedRect
        self.keyboardType = .default
        
        self.placeholder = "텍스트를 입력해 주세요"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

//
//  LinkButton.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit

final class LinkButton: UIButton {
    private let url: String
    init(url: String) {
        self.url = url
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
    
    @objc func pressed() {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

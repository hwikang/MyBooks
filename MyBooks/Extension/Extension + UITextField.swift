//
//  Extension + UITextField.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

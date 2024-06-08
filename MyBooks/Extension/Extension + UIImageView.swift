//
//  Extension + UIImageView.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit


extension UIImageView {
    func setImage(urlString: String) {
        
        if let cachedImage = ImageCacheManager.shared.image(forKey: urlString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                    
                    ImageCacheManager.shared.setImage(downloadedImage, forKey: urlString)
                    
                    DispatchQueue.main.async {
                        self?.image = downloadedImage
                    }
                }.resume()
            }
        }
    }
}

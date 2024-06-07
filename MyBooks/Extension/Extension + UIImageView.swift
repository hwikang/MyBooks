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

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        if let fileURL = fileURL(for: key), let data = image.pngData() {
            do {
                try data.write(to: fileURL)
            } catch {
                print("Failed to save data: \(error)")
            }
        }

    }
    
    func image(forKey key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        
        if let fileURL = fileURL(for: key),
           let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            cache.setObject(image, forKey: key as NSString)
            return image
        }
        return nil
        
    }
    
    private func fileURL(for key: String) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return cacheDirectory.appendingPathComponent(key.replacingOccurrences(of: "/", with: "-"))
    }
}

//
//  CacheManager.swift
//  MyBooks
//
//  Created by paytalab on 6/8/24.
//

import UIKit
import PDFKit

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


class PDFCacheManager {
    static let shared = PDFCacheManager()
    private init() {}

    private let cache = NSCache<NSString, PDFDocument>()

    func setDocument(_ document: PDFDocument, forKey key: String) {
        cache.setObject(document, forKey: key as NSString)
        
        if let fileURL = fileURL(for: key), let data = document.dataRepresentation() {
            do {
                try data.write(to: fileURL, options: .atomicWrite)
            } catch {
                print("Failed to save data: \(error)")
            }
        }

    }
    
    func document(forKey key: String) -> PDFDocument? {
        if let document = cache.object(forKey: key as NSString) {
            return document
        }
        
        if let fileURL = fileURL(for: key),
           let documentData = try? Data(contentsOf: fileURL),
           let document = PDFDocument(data: documentData) {
            cache.setObject(document, forKey: key as NSString)
            return document
        }
        return nil
        
    }
    
    private func fileURL(for key: String) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return cacheDirectory.appendingPathComponent(key.replacingOccurrences(of: "/", with: "-"))
    }
}

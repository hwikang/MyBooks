//
//  Extension + PDFView.swift
//  MyBooks
//
//  Created by paytalab on 6/8/24.
//

import UIKit
import PDFKit

extension PDFView {
    func setDocument(urlString: String) {
        
        if let document = PDFCacheManager.shared.document(forKey: urlString) {
            DispatchQueue.main.async { [weak self] in
                self?.document = document
            }
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let pdfDocument = PDFDocument(data: data) else { return }
                    
                    PDFCacheManager.shared.setImage(pdfDocument, forKey: urlString)
                    
                    DispatchQueue.main.async {
                        self?.document = pdfDocument
                    }
                }.resume()
            }
        }
    }
}

class PDFCacheManager {
    static let shared = PDFCacheManager()
    private init() {}

    private let cache = NSCache<NSString, PDFDocument>()

    func setImage(_ document: PDFDocument, forKey key: String) {
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

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
                    
                    PDFCacheManager.shared.setDocument(pdfDocument, forKey: urlString)
                    
                    DispatchQueue.main.async {
                        self?.document = pdfDocument
                    }
                }.resume()
            }
        }
    }
}

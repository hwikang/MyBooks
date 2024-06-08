//
//  BookView.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit
import PDFKit

final class BookView: UIView {
    
    let scrollView = UIScrollView()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let publisherLabel = UILabel()
    let priceLabel = UILabel()
    let authorLabel = UILabel()
    let languageLabel = UILabel()
    let yearLabel = UILabel()
    let ratingLabel = UILabel()
    let descLabel = UILabel()
    let isbnLabel = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    public func setContent(book: Book) {
        bookImage.setImage(urlString: book.image)
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        publisherLabel.text = book.publisher
        priceLabel.text = book.price
        authorLabel.text = book.authors
        languageLabel.text = book.language
        yearLabel.text = "\(book.year) Year"
        ratingLabel.text = "Rating : \(book.rating) / 5"
        isbnLabel.text = "ISBN13: \(book.isbn13) ISBN10: \(book.isbn10)"
        descLabel.text = book.desc
        addLinkButtonToStackView(title: "Go to Store", url: book.url)
        
    }
    
    public func setPDF(pdf: [[String: String]].Element) {
        pdf.forEach { addImageViewToStackView(element: $0) }
    }
    
    private func addImageViewToStackView(element: [String: String].Element) {
        
        let label = UILabel()
        label.text = element.key
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pdfView.heightAnchor.constraint(equalToConstant: 540),
        ])
        pdfView.setDocument(urlString: element.value)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(pdfView)
    }
    
    private func addLinkButtonToStackView(title: String, url: String) {
        let button = LinkButton(url: url)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        stackView.addArrangedSubview(button)
    }
    
    private func setUI() {
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.numberOfLines = 2
        subTitleLabel.numberOfLines = 2
        descLabel.numberOfLines = 0
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        [bookImage, titleLabel, subTitleLabel, publisherLabel, priceLabel,  authorLabel, languageLabel, yearLabel, ratingLabel, descLabel, isbnLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        setConstraint()
    }
    
    private func setConstraint() {
        [scrollView, stackView, bookImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            bookImage.heightAnchor.constraint(equalToConstant: 340),
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

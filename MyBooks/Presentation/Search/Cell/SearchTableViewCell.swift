//
//  SearchTableViewCell.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit

class SearchTableViewCell : UITableViewCell {
    static let identifier = "BookTableViewCell"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2

        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 2
        return label
    }()
    let priceLabel = UILabel()
   
    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let isbnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    func configure(book: BookListItem) {
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        priceLabel.text = book.price
        bookImage.setImage(urlString: book.image)
        isbnLabel.text = book.isbn13
        urlLabel.text = book.url
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImage.image = UIImage(named: "placeholder")
    }
    
    private func setUI() {
        [titleLabel, subTitleLabel, priceLabel, bookImage, isbnLabel, urlLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookImage.widthAnchor.constraint(equalToConstant: 100),
            bookImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: bookImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            isbnLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            isbnLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            
            urlLabel.bottomAnchor.constraint(equalTo: isbnLabel.topAnchor),
            urlLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor),
        ])
    }
      
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
      
}

//
//  Book.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

struct BookListItem: Decodable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String

}

struct Book: Decodable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
    let authors: String
    let publisher: String
    let language: String
    let isbn10: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let pdf: [String:String]?
    
}

//
//  BookList.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

struct BookList: Decodable {
    var page: Int
    var total: Int
    let books: [BookListItem]
    
    enum CodingKeys: CodingKey {
        case page, total, books
    }
    init(page: Int, total: Int, books:[BookListItem]) {
        self.page = page
        self.total = total
        self.books = books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pageString = try container.decode(String.self, forKey: CodingKeys.page)
        let totalString = try container.decode(String.self, forKey: CodingKeys.total)
        guard let pageInt = Int(pageString) else {
            throw NetworkError.failToDecode("Decoding BookList Page Error")
        }
        guard let totalInt = Int(totalString) else {
            throw NetworkError.failToDecode("Decoding BookList Total Error")
        }
        page = pageInt
        total = totalInt
        books = try container.decode([BookListItem].self, forKey: CodingKeys.books)
    }
   
}

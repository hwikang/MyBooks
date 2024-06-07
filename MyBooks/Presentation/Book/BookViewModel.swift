//
//  BookViewModel.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import Foundation
import Combine

protocol BookViewModelProtocol {
    func transform(input: BookViewModel.Input) -> BookViewModel.Output
}

final class BookViewModel: BookViewModelProtocol {
    private let repository: BookRepositoryProtocol
    private let isbn: String
    private var cancellables = Set<AnyCancellable>()
    private let book = PassthroughSubject<Book,Never>()
    private let errorMessage = PassthroughSubject<String,Never>()
    
    struct Input {
        var trigger: AnyPublisher<Void,Never>
    }
    
    struct Output {
        var book: AnyPublisher<Book,Never>
        var errorMessage: AnyPublisher<String,Never>
    }
    
    init(repository: BookRepositoryProtocol, isbn: String) {
        self.repository = repository
        self.isbn = isbn
    }
    func transform(input: BookViewModel.Input) -> BookViewModel.Output {
        input.trigger.sink { [weak self] in
            self?.searchBook()
        }.store(in: &cancellables)
        
        return Output(book: book.eraseToAnyPublisher(), errorMessage: errorMessage.eraseToAnyPublisher())
    }
 
    private func searchBook() {
        Task { [weak self] in
            guard let self = self else { return }
            let searchResult = await repository.bookDetail(isbn: isbn)
            switch searchResult {
            case .success(let book):
                self.book.send(book)
            case .failure(let error):
                errorMessage.send(error.description)
            }
        }
    }
    
}

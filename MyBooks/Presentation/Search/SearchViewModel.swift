//
//  SearchViewModel.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output
}

final class SearchViewModel: SearchViewModelProtocol {
    private let repository: BookRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let bookList = CurrentValueSubject<[BookListItem],Never>([])
    private let errorMessage = PassthroughSubject<String,Never>()
    private let latestQuery = CurrentValueSubject<String,Never>("")

    private var page = 1
    struct Input {
        let searchText: AnyPublisher<String,Never>
        let loadMore: AnyPublisher<Void,Never>
    }
    struct Output {
        let bookList: AnyPublisher<[BookListItem],Never>
        let errorMessage: AnyPublisher<String,Never>
    }
    
    init(repository: BookRepositoryProtocol){
        self.repository = repository
    }
    
    public func transform(input: Input) -> Output {
        input.searchText
            .removeDuplicates()
            .filter({ [weak self] query in
                return self?.filterQuery(query: query) == true
            })
            .compactMap { text in
                return text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }
            .sink { [weak self] text in
                guard let self = self else { return }
                page = 1
                bookList.send([])
                latestQuery.send(text)
                search(query: text, page: page)
            }
            .store(in: &cancellables)
        
        input.loadMore
            .compactMap { [weak self] in
                return self?.latestQuery.value
            }
            .sink { [weak self] text in
                guard let self = self else { return }
                page += 1
                search(query: text, page: page)
            }.store(in: &cancellables)
            
        return Output(bookList: bookList.eraseToAnyPublisher(), errorMessage: errorMessage.eraseToAnyPublisher())
    }
    
    private func search(query: String, page: Int) {
        
        Task { [weak self] in
            guard let self = self else { return }
            let searchResult = await repository.searchBooks(query: query, page: page)
            switch searchResult {
            case .success(let searchList):
                bookList.send(bookList.value + searchList.books)
            case .failure(let error):
                errorMessage.send(error.description)
            }
        }
    }
    
    private func filterQuery(query: String) -> Bool {
        if query.count < 2 {
            return false
        } else if queryValidation(query: query) == false {
            errorMessage.send("유효 하지 않은 검색어입니다")
            return false
        } else {
            return true
        }
    }
    
    private func queryValidation(query: String) -> Bool {
        let regex = "^[a-zA-Z0-9]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: query)
    }

}

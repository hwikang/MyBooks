//
//  SearchViewController.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    private let viewModel: SearchViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let books = CurrentValueSubject<[Book], Never>([])
    private let loadMoreSubject = PassthroughSubject<Void, Never>()

    private let textField = SearchTextField()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        bindView()
    }
    
    private func setUI() {
        [textField, tableView].forEach {
            view.addSubview($0)
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraint()
    }
    private func bindViewModel() {
        let input = SearchViewModel.Input(searchText: textField.textPublisher, loadMore: loadMoreSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.bookList
            .receive(on: DispatchQueue.main)
            .sink {[weak self] books in
                self?.books.send(books)
            }.store(in: &cancellables)
        
        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink {[weak self] errorMessage in
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    private func bindView() {
        books
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.value.count
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let itemIndex = indexPaths.last?.item, itemIndex >= books.value.count - 1 {
            loadMoreSubject.send(())
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
        let book = books.value[indexPath.row]
        
        (cell as? SearchTableViewCell)?.configure(book: book)
        return cell
    }
    
}

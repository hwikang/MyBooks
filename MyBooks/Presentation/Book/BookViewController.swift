//
//  BookViewController.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit
import Combine

final class BookViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let trigger = PassthroughSubject<Void,Never>()
    private let viewModel: BookViewModelProtocol
    private let bookView = BookView()
    
    init(viewModel: BookViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trigger.send()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        trigger.send(())
    }
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(bookView)
        bookView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bookView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bookView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    private func bindViewModel() {
        let input = BookViewModel.Input(trigger: trigger.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.book
            .receive(on: DispatchQueue.main)
            .sink {[weak self] book in
                guard let self = self else { return }
                bookView.setContent(book: book)
                
            }
            .store(in: &cancellables)
        
        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink {[weak self] errorMessage in
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  SearchViewCoordinator.swift
//  MyBooks
//
//  Created by paytalab on 6/7/24.
//

import UIKit

struct SearchViewCoordinator {
    private let nav: UINavigationController
    init(nav: UINavigationController) {
        self.nav = nav
    }
    public func pushBookViewController(isbn: String) {
        let session = BookURLSession()
        let network = BookNetwork(network: NetworkManager(session: session))
        let repository = BookRepository(network: network)
        let viewModel = BookViewModel(repository: repository, isbn: isbn)
        let viewController = BookViewController(viewModel: viewModel)
        nav.pushViewController(viewController, animated: true)
    }
}

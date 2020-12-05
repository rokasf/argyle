//
//  ViewController.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import UIKit
import WebKit

class SearchViewController: UIViewController {
    private let tableView = UITableView()
    private var viewModel: SearchViewModel
    private var searchTimer: Timer?


    init(_ viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupSearchController()
        setupTableView()
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.placeholder
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.becomeFirstResponder()
        navigationItem.searchController = searchController
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.cellId)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellId) {
            cell.textLabel?.textAlignment = .left
            if indexPath.row >= viewModel.items.count {
                if viewModel.rowCount - indexPath.row == 1 && viewModel.isNextVisible {
                    cell.textLabel?.text = viewModel.nextText
                    cell.textLabel?.textAlignment = .right
                    return cell
                }
                cell.textLabel?.text = viewModel.previousText
            } else {
                cell.textLabel?.text = viewModel.items[indexPath.row].name
                
                if viewModel.items[indexPath.row].loginUrl != nil {
                    cell.accessoryType = .disclosureIndicator
                } else {
                    cell.accessoryType = .none
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.items.count {
            if viewModel.rowCount - indexPath.row == 1 && viewModel.isNextVisible {
                viewModel.loadNext { [weak self] in
                    self?.tableView.reloadData()
                }
            } else {
                viewModel.loadPrevious { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        } else {
            if let url = viewModel.items[indexPath.row].loginUrl {
                let webViewController = WebViewController(url)
                webViewController.navigationItem.title = viewModel.items[indexPath.row].name
                navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count >= viewModel.minTextCount {
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: viewModel.searchInterval,
                                               repeats: false){ [weak self] (timer) in
                self?.viewModel.search(text) {
                    self?.tableView.reloadData()
                }
            }
        } else {
            viewModel.resetData()
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetData()
        tableView.reloadData()
    }
}

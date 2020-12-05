//
//  SearchViewModel.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import Foundation

class SearchViewModel {
    let minTextCount = 2
    let limit = 15
    let offset = 0
    let searchInterval = 0.5
    let placeholder = "Companies and Platforms supported by Argyle"
    let cellId = "ReuseCellId"
    let previousText = "PREVIOUS"
    let nextText = "NEXT"

    private var response: Response?
    private let apiService: API

    var items: [Item] {
        return response?.results ?? []
    }

    var rowCount: Int {
        return items.count + (isPreviousVisible ? 1 : 0) + (isNextVisible ? 1 : 0)
    }

    var isPreviousVisible: Bool {
        if let response = response {
           return response.previous != nil
        }
        return false
    }

    var isNextVisible: Bool {
        if let response = response {
           return response.next != nil
        }
        return false
    }

    init(_ apiService: API) {
        self.apiService = apiService
    }

    func search(_ text: String, _ callback: @escaping ()->()) {
        apiService.search(text: text, limit: limit, offset: offset) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.response = response
                    callback()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func loadPrevious(_ callback: @escaping ()->()) {
        if let url = response?.previous {
            apiService.load(url: url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.response = response
                        callback()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func loadNext(_ callback: @escaping ()->()) {
        if let url = response?.next {
            apiService.load(url: url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.response = response
                        callback()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func resetData() {
        response = nil
    }
}

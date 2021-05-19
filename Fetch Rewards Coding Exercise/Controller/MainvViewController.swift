//
//  MainvViewController.swift
//  Fetch Rewards Coding Exercise
//
//  Created by Abraham Estrada on 5/19/21.
//

import UIKit
import SwiftyJSON

private let cellIdentifier = "cell"

class MainViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var filteredEvents = [Event]()
    
    private var API = SeatGeekAPIService()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        tableView.register(EventCell.self, forCellReuseIdentifier: cellIdentifier)
        API.delegate = self
        API.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

// MARK: - UITableViewDataSource

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredEvents.count : events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventCell
        cell.event = inSearchMode ? filteredEvents[indexPath.row] : events[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = EventController()
        controller.event = inSearchMode ? filteredEvents[indexPath.row] : events[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SeatGeekAPIServiceDelegate

extension  MainViewController: SeatGeekAPIServiceDelegate {
    func didFetchData(data: JSON) {
        for index in 0..<data["events"].arrayValue.count {
            events.append(Event(data: data, index: index))
        }
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filteredEvents = events.filter{$0.name.contains(searchText) || $0.name.lowercased().contains(searchText)}
        self.tableView.reloadData()
    }
}

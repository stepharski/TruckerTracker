//
//  LocationSearchVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/1/22.
//

import UIKit
import MapKit

class LocationSearchVC: UIViewController {
    
    var searchBar = UISearchBar()
    var searchResultsTable = UITableView()
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    init(searchBar: UISearchBar = UISearchBar(), searchResultsTable: UITableView = UITableView(), searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter(), searchResults: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]()) {
        super.init(nibName: nil, bundle: nil)
        
        self.searchBar = searchBar
        self.searchResultsTable = searchResultsTable
        self.searchCompleter = searchCompleter
        self.searchResults = searchResults
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
    }

    func configure() {
        view.backgroundColor = .black
        
        configureNavBar()
        configureSearchBar()
        configureSearchResultsTable()
    }
    
    func configureNavBar() {
        navigationItem.title = "Location"
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.backgroundColor = .red
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: padding),
            searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding),
            searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSearchResultsTable() {
        view.addSubview(searchResultsTable)
        
        searchResultsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchResultsTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


//MARK: - UISearchBarDelegate
extension LocationSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LocationSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = searchResults[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            print(lat)
            print(lon)
            print(name)
        }
    }
}

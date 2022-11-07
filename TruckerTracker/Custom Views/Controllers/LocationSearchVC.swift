//
//  LocationSearchVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/1/22.
//

import UIKit
import MapKit

class LocationSearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectLocationButton: UIButton!
    
    var selectedLocation: String?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    let searchBarColor: UIColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
    let searchBarTextColor: UIColor = #colorLiteral(red: 0.1137254902, green: 0.1098039216, blue: 0.1294117647, alpha: 1)
    let searchBarBackgroundColor: UIColor = #colorLiteral(red: 0.07058823529, green: 0.1019607843, blue: 0.09411764706, alpha: 1)
    
    
    var searchIsActive: Bool = true {
        didSet {
            mapView.isHidden = searchIsActive
            selectLocationButton.isHidden = searchIsActive
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureSearchBar()
        overrideUserInterfaceStyle = .dark
        
        searchBar.delegate = self
        searchCompleter.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func xButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectLocationTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func configureSearchBar() {
        searchIsActive = true
        searchBar.becomeFirstResponder()
        searchBar.text = selectedLocation ?? ""
        
        searchBar.barTintColor = searchBarBackgroundColor
        searchBar.searchTextField.backgroundColor = searchBarColor
        searchBar.setClearButtonColorTo(color: searchBarTextColor)
        searchBar.setMagnifyingGlassColorTo(color: searchBarTextColor)
        searchBar.setPlaceholderTextColorTo(color: searchBarTextColor)
    }
    
    func configureMapView() {
        mapView.layer.cornerRadius = 10
    }
    
    func setMapPin(location: CLLocationCoordinate2D, name: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name ?? "Here"
        
        //TODO: Pass city and Country
        annotation.subtitle = "City, Country"
        
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate,
                                                  latitudinalMeters: 300,
                                                  longitudinalMeters: 300)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}


//MARK: - UISearchBarDelegate
extension LocationSearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
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
        var contentConfig = cell.defaultContentConfiguration()
        
        cell.backgroundColor = .clear
        contentConfig.textProperties.color = .white
        contentConfig.secondaryTextProperties.color = .white
        contentConfig.text = result.title
        contentConfig.secondaryText = result.subtitle
        
        cell.contentConfiguration = contentConfig

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

            self.searchIsActive = false
            self.searchBar.endEditing(true)
            
            self.searchResults = [result]
            tableView.reloadData()
            
            let name = response?.mapItems[0].name
            self.setMapPin(location: coordinate, name: name)
        }
    }
}

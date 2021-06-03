//
//  AddLocationViewController.swift
//  hey m8
//
//  Created by Christina Li on 21/5/21.
//
// https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UISearchResultsUpdating {


    let mapView = MKMapView()
    let searchVC = UISearchController(searchResultsController: LocationResultsViewController())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }

    func updateSearchResults(for searchController: UISearchController) {
    
    }

}

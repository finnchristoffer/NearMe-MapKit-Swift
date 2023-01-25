//
//  ViewController.swift
//  NearMe
//
//  Created by Finn Christoffer Kurniawan on 25/01/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
    }
    // MARK: - Helpers

    private func setupUI() {
        view.addSubview(mapView)
    }



}


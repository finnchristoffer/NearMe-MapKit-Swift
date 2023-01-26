//
//  ViewController.swift
//  NearMe
//
//  Created by Finn Christoffer Kurniawan on 25/01/23.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    lazy var mapView: MKMapView = {
        let map = MKMapView()
//        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
       let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    // MARK: - Helpers

    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        view.bringSubviewToFront(searchTextField)
        searchTextField.returnKeyType = .go
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerX.equalTo(self.view)
            make.width.equalTo(view.bounds.size.width/1.2)
            make.top.equalTo(60)
        }
    }

}


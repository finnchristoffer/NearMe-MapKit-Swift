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
    private var places = [PlaceAnnotation]()
    var locationManager: CLLocationManager?
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
       let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "What you wanna search ?"
        searchTextField.layer.borderWidth = 1
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
        
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
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("Location services has been denied.")
        case .notDetermined, .restricted:
            print("Location cannot be determined or restricted.")
        @unknown default:
            print("Unknown error. Unable to get location.")
        }
    }
    
    private func presentPlacesSheet(places: [PlaceAnnotation]) {
        
        guard let locationManager = locationManager,
        let userLocation = locationManager.location
        else { return }
        
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }
    
    private func findNearbyPlaces(by query: String) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self]response, error in
            guard let response = response, error == nil else {return}
            
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            if let places = self?.places {
                self?.presentPlacesSheet(places: places)
            }
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearbyPlaces(by: text)
        }
        return true
    }
}

extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelection() {
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        clearAllSelection()
        guard let selectionAnnotation = annotation as? PlaceAnnotation else {return}
        
        let placeAnnotation = self.places.first(where: { $0.id == selectionAnnotation.id})
        placeAnnotation?.isSelected = true
        
        presentPlacesSheet(places: self.places)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


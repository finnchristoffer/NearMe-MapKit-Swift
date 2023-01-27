//
//  PlaceDetailViewController.swift
//  NearMe
//
//  Created by Finn Christoffer Kurniawan on 27/01/23.
//

import Foundation
import UIKit
import SnapKit

class PlaceDetailViewController: UIViewController {
    
    let place: PlaceAnnotation
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    
    private lazy var directionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Direction", for: .normal)
        return button
    }()
    
    private lazy var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        let stackview = UIStackView()
        stackview.alignment = .leading
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = UIStackView.spacingUseSystem
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        stackview.addArrangedSubview(nameLabel)
        stackview.addArrangedSubview(addressLabel)
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem
        
        directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        
        contactStackView.addArrangedSubview(directionButton)
        contactStackView.addArrangedSubview(callButton)
        
        stackview.addArrangedSubview(contactStackView)
        
        view.addSubview(stackview)
    }
    
    // MARK: - Selectors
    
    @objc func directionButtonTapped(_ sender: UIButton) {
        
        let coordinate = place.location.coordinate
        guard let url = URL(string: "https://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {return}
        
        UIApplication.shared.open(url)
    }
    
    @objc func callButtonTapped(_ sender: UIButton) {
        
        guard let url = URL(string: "tel://\(place.phone.formatPhoneForCall)") else { return }
        UIApplication.shared.open(url)
    }
    
    
}

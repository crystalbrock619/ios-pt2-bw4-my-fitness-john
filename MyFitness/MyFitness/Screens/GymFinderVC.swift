//
//  GymFinderVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GymFinderVC: UIViewController {
    
    var gymMapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    var arrayOfResults: [MKMapItem] = []
    
    var gym: MKPointOfInterestCategory = .fitnessCenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        locationManager.requestWhenInUseAuthorization()
        
        setupGymMapView()
        setupUserTrackingButton()
        searchInMap()
    }
    
    func searchInMap() {
        // Create request
        let request = MKLocalSearch.Request()
        // Including array of MLPointOfInterestCategory
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [gym])
        // Run search
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (response, error) in
            
            if response == nil {
                print("error")
            }
            
            if let response = response {
                for item in response.mapItems {
                    self.addPinToMapView(title: item.name,
                                         latitude: item.placemark.location!.coordinate.latitude,
                                         longitude: item.placemark.location!.coordinate.longitude)
                    self.arrayOfResults.append(item)
                }
            }
        })
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            gymMapView.addAnnotation(annotation)
        }
    }
    
    private func setupGymMapView() {
        gymMapView = MKMapView(frame: view.bounds)
        gymMapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gymMapView)
        
        NSLayoutConstraint.activate([
            gymMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gymMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gymMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gymMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupUserTrackingButton() {
        userTrackingButton = MKUserTrackingButton(mapView: gymMapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: gymMapView.leadingAnchor, constant: 30),
            userTrackingButton.bottomAnchor.constraint(equalTo: gymMapView.bottomAnchor, constant: -30)
        ])
    }
    
}

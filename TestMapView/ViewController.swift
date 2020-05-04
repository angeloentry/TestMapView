//
//  ViewController.swift
//  TestMapView
//
//  Created by user167484 on 4/13/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController: UISearchController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSearchController()
        
        let london = MKPointAnnotation()
        london.title = "London"
        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        mapView.showAnnotations([london], animated: true)
    }
    
    func setupSearchController() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! MapTableViewController
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
    }
}



extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else {
            return
        }
        let coordinate2D = annotation.coordinate
        let location = CLLocation(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
        lookUpCurrentLocation(location: location) { [weak self] (placemark) in
            guard let mark = placemark else { return }
            let localityInfo = "\(mark.locality ?? ""), \(mark.subAdministrativeArea ?? ""), \(mark.administrativeArea ?? ""), "
            let countryInfo = "\(mark.country ?? ""), \(mark.postalCode ?? "")"
            let totalAddress = localityInfo + countryInfo
            guard let detailVC = self?.storyboard?.instantiateViewController(identifier: "MapDetailViewController") as? MapDetailViewController else { return }
            detailVC.address = totalAddress
            self?.present(detailVC, animated: true)
        }
    
    }
    
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?)
                -> Void ) {
    // Use the last reported locatilet geocoder = CLon.
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
             // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
}


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}



extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark) {
        // cache the pin
        // clear existing pins
         // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

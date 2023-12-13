//
//  LocationManager.swift
//  LocationSearch
//
//  Created by Mark Darlas on 29/3/24.
//

import SwiftUI
import CoreLocation
import MapKit
//MARK: Combine framework to watch textfield change
import Combine

class LocationManager: NSObject, ObservableObject,MKMapViewDelegate,CLLocationManagerDelegate   {
    //MARK: Properties
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    //MARK: Search Bar Text
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    
    //MARK: user location
    @Published var userLocation: CLLocation?
    
    
    //mark: final location
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    override init(){
        super.init()
        //MARK: setting delegates
        manager.delegate = self
        mapView.delegate = self
        
        //MARK: requesting location access
        manager.requestWhenInUseAuthorization()
        
        //MARK:Search textfield watching
        cancellable = $searchText
            .debounce(for:.seconds(0.8), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue:{value in
                if value != "" {
                    self.fetchPlaces(value: value)
                }else{
                    self.fetchedPlaces = nil
                }
            })
    }
    
    func fetchPlaces(value:String){
     // fetching places using  MKLocalSearch & Async/Await
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request:request).start()
                
                await MainActor.run(body:{
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in return item.placemark})
                })
            }
            catch{
                //handle error
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //handle error
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else{
            print("Error: No location data available")
            return
        }
        print("Current location updated: \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
               self.userLocation = currentLocation
        self.userLocation = currentLocation
        
    }
    //location auth
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Location authorization granted")
                    manager.requestLocation()
                case .denied, .restricted:
                    print("Location authorization denied or restricted")
                    // Handle denied or restricted authorization
                case .notDetermined:
                    print("Location authorization not determined")
                    manager.requestWhenInUseAuthorization()
                @unknown default:
                    print("Unknown authorization status")
                }
    func handleLocationError(){
            
        }
    }
    func addDraggablePin(coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Reported Incident location"
        
        mapView.addAnnotation(annotation)
    }
    
    // enabling dragging
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYPIN")
        marker.markerTintColor = UIColor.orange
        marker.isDraggable = true
        marker.canShowCallout = false
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else{
            return
        }
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlaceMark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlaceMark(location: CLLocation){
        Task{
            do{
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run(body:{
                    self.pickedPlaceMark = place
                })
            }
            catch{
                //error
            }
        }
    }
    
    //Display new location data
    func reverseLocationCoordinates(location: CLLocation)async throws -> CLPlacemark?{
        let place = try await  CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
}

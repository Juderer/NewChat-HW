//
//  LocationViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/28.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: BaseViewController {
    var location: LocationAuthorization!
    var authorizationButton: UIButton!
    var locationButton: UIButton!
    var searchButton: UIButton!
    var directionButton: UIButton!
    var mapView: MKMapView!
    var places: [CustomAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Location"
        location = LocationAuthorization()
        location.getCurrentStatus()
        places = CustomAnnotation.places()
        
        authorizationButton = UIButton()
        authorizationButton.backgroundColor = UIColor.blue
        authorizationButton.setTitle("授权", for: .normal)
        authorizationButton.addTarget(self, action: #selector(requestAuthor), for: .touchUpInside)
        self.view.addSubview(authorizationButton)
        authorizationButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        locationButton = UIButton()
        locationButton.backgroundColor = UIColor.blue
        locationButton.setTitle("定位", for: .normal)
        locationButton.addTarget(self, action: #selector(locationAction), for: .touchUpInside)
        self.view.addSubview(locationButton)
        locationButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.authorizationButton.snp.right).offset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        searchButton = UIButton()
        searchButton.backgroundColor = UIColor.blue
        searchButton.setTitle("搜索", for: .normal)
        searchButton.addTarget(self, action: #selector(searchPlaces), for: .touchUpInside)
        self.view.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.locationButton.snp.right).offset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        directionButton = UIButton()
        directionButton.backgroundColor = UIColor.blue
        directionButton.setTitle("导航", for: .normal)
        directionButton.addTarget(self, action: #selector(searchDirection), for: .touchUpInside)
        self.view.addSubview(directionButton)
        directionButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.searchButton.snp.right).offset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        addMapView()
    }
    
    @objc func requestAuthor() {
        location.requestForAuthorization()
    }
    
    @objc func locationAction() {
        location.startLocation()
    }
}

extension LocationViewController: MKMapViewDelegate {
    
    func addMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.authorizationButton.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.addOverlay()
            self.addPolyLine()
        }
    }
    
    func addAnnotation() {
        if let place = places {
            mapView.addAnnotations(place)
        }
    }
    
    func addOverlay() {
        if let place = CustomAnnotation.places() {
            let circle1 = MKCircle(center: place[0].coordinate, radius: 10000)
            mapView.addOverlays([circle1])
        }
    }
    
    func addPolyLine() {
        if let place = CustomAnnotation.places() {
            let coords = [place[0].coordinate, place[1].coordinate, place[2].coordinate]
            let polyLine = MKPolyline(coordinates: coords, count: 3)
            mapView.addOverlay(polyLine)
        }
    }
    
    //MARK: - Delegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.zoomLevel = 6
        userLocation.title = "我在这里"
        userLocation.subtitle = "欢迎来我的家"
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
//            return nil
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            let icon = UIImageView(image: UIImage(named: "cat1"))
            icon.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            annotationView.leftCalloutAccessoryView = icon

            let rightView = UIImageView(image: UIImage(named: "right_angle"))
            icon.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            annotationView.rightCalloutAccessoryView = rightView

            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "place_icon")
            return annotationView
        }

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "CoffeeView")
        if pinView == nil {
            pinView = MKAnnotationView()
            pinView?.image = UIImage(named: "coffee")
            pinView?.canShowCallout = true
        }
        return pinView!
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.red
            lineView.lineWidth = 2
            return lineView
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
}


extension MKMapView {
    //缩放级别范围是：2 - 20（其中 2 为世界地图）
    var zoomLevel: Int {
        //获取缩放级别
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256)
                / self.region.span.longitudeDelta)) + 1)
        }
        //设置缩放级别
        set (newZoomLevel){
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel,
                                animated: false)
        }
    }
     
    //设置缩放级别时调用
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int,
                                     animated: Bool){
        let span = MKCoordinateSpan(latitudeDelta: 0,
                                    longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: centerCoordinate, span: span), animated: animated)
    }
}


extension LocationViewController {
    @objc func searchPlaces() {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "1981"
        request.region = mapView.region
        request.resultTypes = [.pointOfInterest]
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.cafe])
        let search = MKLocalSearch(request: request)
        mapView.removeAnnotations(mapView.annotations)
        search.start { (response, error) in
            if let resp = response {
                var annotations = [SearchPlace]()
                for place in resp.mapItems {
                    annotations.append(SearchPlace(coordinate: place.placemark.coordinate,
                                                   title: place.name,
                                                   subtitle: place.phoneNumber))
                }
                self.mapView.addAnnotations(annotations)
            }
        }
        
    }
}

extension LocationViewController {
    
    @objc func searchDirection() {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: places![0].coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: places![1].coordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let resp = response {
                self.mapView.removeOverlays(self.mapView.overlays)
                for route in resp.routes {
                    self.mapView.addOverlay(route.polyline)
                }
                let region = MKCoordinateRegion(resp.routes[0].polyline.boundingMapRect)
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
}



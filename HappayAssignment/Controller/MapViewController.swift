//
//  MapViewController.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 09/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    var data :Location!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("data:\(data.city)")
        self.navigationItem.title = data.city
        plotonMap()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension MapViewController: MKMapViewDelegate {
    // 1
    func plotonMap(){
        mapView.mapType = MKMapType.hybrid
        // 2)
        let location = CLLocationCoordinate2D(latitude:data.latitude,longitude:data.longitude)
        // 3)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        // 4)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Country:\(data.country)"
        annotation.subtitle = "City:\(data.city)"
        mapView.addAnnotation(annotation)
    }
}

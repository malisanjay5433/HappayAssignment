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
    var id:String?
    var table_Data = [BikerModel]()
    var stations = [ArrStations]()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("data:\(data.city)")
        print("Id:\(id!)")
        self.navigationItem.title = data.city
        plotonMap()
        downloadJSON()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 100
        self.tableView.tableFooterView = UIView()
        
    }
}
extension MapViewController: MKMapViewDelegate {
    //Convert String Timestamp to Date
    func convertDateFormatter(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy MMM EEEE"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date!)
        if timeStamp != nil {
        return timeStamp
        }else{
            return ""
        }
    }
    //Annoataion is  display on map
    func plotonMap(){
        mapView.mapType = MKMapType.hybridFlyover
        let location = CLLocationCoordinate2D(latitude:data.latitude,longitude:data.longitude)
        let span = MKCoordinateSpanMake(2.0, 2.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Country:\(data.country)"
        annotation.subtitle = "City:\(data.city)"
        mapView.addAnnotation(annotation)
    }
    func downloadJSON(){
        let jsonUrl = "https://api.citybik.es/v2/networks/\(id!)"
        print("jsonUrl:\(jsonUrl)")
        DataManager.getJSONFromURL(jsonUrl) { (data, error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(NewBikerModel.self, from: data)
                self.stations = json.network.stations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = "Stations:\(self.stations.count)"
                }
            } catch{
                print("failed to convert data")
                self.navigationItem.title = "Stations:\(self.stations.count)"
            }
        }
    }
}

extension MapViewController:UITableViewDelegate,UITableViewDataSource{
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stations.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StationCellTableViewCell
        let data = stations[indexPath.row]
        cell.backView.layer.cornerRadius = 10
        cell.backView.layer.masksToBounds = true
        cell.name_Lbl?.text = "Name:\(data.name)"
        cell.empty_slots?.text = "Slots:\(data.empty_slots)"
        cell.free_bikes.text = "FreeBike:\(data.free_bikes)"
        let date = convertDateFormatter(date: data.timestamp)
        cell.timestamp?.text = date
        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
}

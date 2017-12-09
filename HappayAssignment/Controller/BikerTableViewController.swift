//
//  BikerTableViewController.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 07/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
class BikerTableViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var searchbar: UISearchBar!
    var table_Data = [BikerModel]()
    var network = [Networks]()
    var filtered_Data = [Networks]()
    var searchActive : Bool = false
    var data:Location?
    let jsonUrl = "https://api.citybik.es/v2/networks"
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.placeholder = "Search here..."
        self.tableView.rowHeight = 80
        self.searchbar.delegate = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "Image"))
        tableView.keyboardDismissMode = .onDrag
        downloadJSON()
    }
    func downloadJSON(){
        DataManager.getJSONFromURL(jsonUrl) { (data, error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(BikerModel.self, from: data)
                self.table_Data = [json]
                for i in self.table_Data{
                    self.network = i.networks
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch{
                print("failed to convert data")
                self.navigationItem.title = "Something Went Wrong"
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive == true {
            return filtered_Data.count
        }else{
            return network.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BikeCell
        let data = network[indexPath.row]
        cell.backView.layer.cornerRadius = 10
        cell.backView.layer.masksToBounds = true
        if searchActive ==  true{
            if filtered_Data.count == 0{
                return cell
            }else{
                let fdata = filtered_Data[indexPath.row]
                cell.name_Lbl.text = fdata.name
            }
        }else{
            cell.name_Lbl?.text = data.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.data = self.network[indexPath.row].location
            self.performSegue(withIdentifier: "MapData", sender:self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MapData"{
            let vc = segue.destination as! MapViewController
            vc.data = self.data
        }
    }
}

extension  BikerTableViewController{
    // MARK: - Searchbar Delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder() // hides the keyboard.

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered_Data = network.filter({ (model:Networks) -> Bool in
            return model.name.lowercased().range(of:searchText.lowercased()) != nil
        })
        if searchText != ""{
            searchActive = true
            self.tableView.reloadData()
            
        }else{
            searchActive = false
            self.tableView.reloadData()
        }
    }
}

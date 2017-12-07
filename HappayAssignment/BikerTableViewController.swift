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
    var netowrk = [Networks]()
    var filtered_Data = [Networks]()
    var searchActive : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.black
        searchbar.placeholder = "Search here..."
        self.tableView.rowHeight = 80
        self.searchbar.delegate = self

        downloadJSON()
    }
    func downloadJSON(){
       let jsonUrl = "https://api.citybik.es/v2/networks"
        let url = URL(string:jsonUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                let json = try JSONDecoder().decode(BikerModel.self, from: data!)
                self.table_Data = [json]
                for i in self.table_Data{
                    self.netowrk = i.networks
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        }.resume()
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
            return netowrk.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BikeCell
        let data = netowrk[indexPath.row]
        if searchActive ==  true{
            if filtered_Data.count == 0{
                return cell
            }
            let fdata = filtered_Data[indexPath.row]
            cell.name_Lbl.text = fdata.name
//            cell.population_Lbl.text = fdata.population
//            cell.name_Lbl.font = font
        }else{
//            cell.name_Lbl.text = kdata.name
            cell.name_Lbl.text = data.id
            
        }
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered_Data = netowrk.filter({ (model:Networks) -> Bool in
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

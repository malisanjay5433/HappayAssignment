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
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.placeholder = "Search here..."
        self.tableView.rowHeight = 80
        self.searchbar.delegate = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "Image"))

        downloadJSON()
//        DataManager.getJSONFromURL("network") { (data, error) in
//                guard let data = data else { return
////                    PlaygroundPage.current.finishExecution()
//                }
//                let decoder = JSONDecoder()
//                do {
//                    let car = try decoder.decode(BikerModel.self, from: data)
//                    print(car)
////                    PlaygroundPage.current.finishExecution()
//                } catch let e {
//                    print("failed to convert data \(e)")
////                    PlaygroundPage.current.finishExecution()
//                }
//            }
        }
    func downloadJSON(){
       let jsonUrl = "https://api.citybik.es/v2/networks"
        let url = URL(string:jsonUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                if data == nil{
                    print("Data nil")
//                    self.tableView.tableHeaderView.
                    return
                }
                let json = try JSONDecoder().decode(BikerModel.self, from: data!)
                self.table_Data = [json]
                print("self:\(self.table_Data)")
                for i in self.table_Data{
                    self.network = i.networks
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("count:\(self.network.count)")
                    for i in self.network{
//                        print("i:\(i.company)")
                    }
                }
            }catch{
                print(error)
            }
        }.resume()
    }
    // MARK: - Table view data source
//    public final class DataManager {
//        public static func getJSONFromURL(_ resource:String, completion:@escaping (_ data:Data?, _ error:Error?) -> Void) {
//            DispatchQueue.global(qos: .background).async {
////                let filePath = Bundle.main.path(forResource: resource, ofType: ".json")
//                let path =  Bundle.main.path(forResource: "network", ofType: "json")
//
//                print("file:\(String(describing: path))")
//                let url = URL(fileURLWithPath:path!)
//                let data = try! Data(contentsOf: url, options: .uncached)
//                completion(data, nil)
//            }
//        }
//    }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.data = self.network[indexPath.row].location
            self.performSegue(withIdentifier: "MapData", sender:self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MapData"{
            var vc = segue.destination as! MapViewController
            vc.data = self.data
        }
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

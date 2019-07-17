//
//  SearchTableViewController.swift
//  Salon
//
//  Created by Rahul Tiwari on 4/29/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
protocol ZipDelegate{
    func LocationOrzip(Zip:String)
}
class SearchTableViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var SearchBar: UISearchBar!
    var location = [String](){
        didSet{
             self.tableView.reloadData()
        }
    }
    var SearchText = String()
    var Delegate:ZipDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchBar.text = SearchText
        self.getRequestAPICall(parameters_name: SearchText)
  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.SearchBar.showsCancelButton = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getRequestAPICall(parameters_name:searchText.removeWhitespace())
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if location.count == 0{
//            self.tableView.backgroundView.add
        }
        return location.count
    }
     
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = location[indexPath.row]
//         cell.textLabel?.text = "location[indexPath.row]"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.Delegate?.LocationOrzip(Zip: self.location[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
    func getRequestAPICall(parameters_name: String)  {
        self.location.removeAll()
        let Url: String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(parameters_name)&key=AIzaSyDPhhaRJ320hsI7lkkRM9pe2sKi9NYjRC4&regions=postal_code,locality,premise&type=geocode"
        
        Alamofire.request(Url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                let json = response.data
                
                do{
                    //created the json decoder
                    let decoder = JSONDecoder()
                    
                    //using the array to put values
                    let loc = try decoder.decode(Location.self, from: json!)
                    let Status = loc.status
                    if Status != "OK" && Status != "INVALID_REQUEST" {
                        self.alert(message: Status)
    
                    }
                    let predict = loc.predictions
                    for Description in predict{
                        self.location.append(Description.description)
                    }
                    print(loc.predictions)
                }
                catch let err{
                    print(err)
                }

        }
    }
}


//
//  ViewController.swift
//  MusixMatchProject
//
//  Created by Sam Roman on 9/10/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchResults = [TrackList]() {
        didSet {
            searchTableView.reloadData()
            print(self.searchResults[0].track.track_name)

            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        if searchResults.count != 0{
        let result = searchResults[indexPath.row].track
        cell.textLabel?.text = result.track_name
        cell.detailTextLabel?.text = result.artist_name
        
    }
        return cell
    }
    

    func loadSearch(str: String){
        SearchAPIClient.getResults(searchTerm: str) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let results):
                    self.searchResults = results
                    print("you got here")
                }
            }
        }
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBarOutlet.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}



extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchTerm = searchBar.text ?? ""
        searchTerm = searchTerm.lowercased().replacingOccurrences(of: " ", with: "-")
        loadSearch(str: searchTerm)
        print(searchTerm)
    }
}

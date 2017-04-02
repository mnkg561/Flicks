//
//  MainViewController.swift
//  Flicks
//
//  Created by Mogulla, Naveen on 3/30/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var movieResults: [NSDictionary] = []
    var originalMovieResults: [NSDictionary] = []
   
    var endpoint: String!
    var movieTitles: [String] = []
    
    @IBOutlet weak var erroImageView: UIImageView!
    @IBOutlet weak var NetworkErrorView: UIView!
    
    @IBOutlet weak var searchBarView: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkErrorView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBarView.delegate = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for:UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        callMovieDatabaseAPI()
        
    }
    
    func callMovieDatabaseAPI() {
        
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        // print("responseDictionary: \(responseDictionary)")
                        
                        self.originalMovieResults = responseDictionary["results"] as! [NSDictionary]
                        
                        for movie in self.originalMovieResults {
                            self.movieTitles.append(movie["title"] as! String)
                        }
                        self.movieResults = self.originalMovieResults
                        print(self.movieTitles)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.tableView.reloadData()
                    }
                } else {
                    self.NetworkErrorView.isHidden = false
                }
        });
        task.resume()
        
        
    }
    
    func refreshControlAction (refreshControl: UIRefreshControl){
        callMovieDatabaseAPI()
        refreshControl.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("number of rows \(movieResults.count)")
        
        return movieResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualMovieCell", for: indexPath) as! IndividualMovieCell
        
        let movie = movieResults[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        
        let baseUrl = "https://image.tmdb.org/t/p/original"
        if let filePath = movie["poster_path"] as? String {
            let posterUrl = URL(string: baseUrl + filePath)
            
            cell.moviePoster.setImageWith(posterUrl!)
        }
        cell.titleLabel.text = title
        cell.overViewLabel.text = overview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let clickedCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: clickedCell)
        let movie = movieResults[indexPath!.row]
        
        let movieDetailViewController = segue.destination as! MovieDetailViewController
        
        movieDetailViewController.movie = movie
        
    }
    
    func searchBar(_ searchBarView: UISearchBar, textDidChange searchText: String){
       
         var searchMovieResults: [NSDictionary] = []
        
        let filteredString = movieTitles.filter { (item: String) -> Bool in
            let stringMatch = item.lowercased().range(of: searchText.lowercased())
            //var stringMatch = item.lowercased().contains("m")
            return stringMatch != nil ? true : false
        }
        print(filteredString)
        
        for movie in self.movieResults {
            for title in filteredString {
                if title.contains (movie["title"] as! String) && !searchMovieResults.contains(movie){
                    searchMovieResults.append(movie)
                }
            }
            
        }
        if (!searchText.isEmpty){
             self.movieResults = searchMovieResults
        } else{
            self.movieResults = self.originalMovieResults // Load the original movie results if search bar is empty
        }
       
        
       self.tableView.reloadData()
        
       
    }
    
    
    
    func searchBarCancelButtonClicked(searchBarView: UISearchBar) {
        print("I got executed")
    }
}

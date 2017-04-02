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

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var movieResults: [NSDictionary] = []
    var endpoint: String!
    
    @IBOutlet weak var erroImageView: UIImageView!
    @IBOutlet weak var NetworkErrorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkErrorView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
                        
                        self.movieResults = responseDictionary["results"] as! [NSDictionary]
                        
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
    
}

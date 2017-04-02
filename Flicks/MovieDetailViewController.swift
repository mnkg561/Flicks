//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Mogulla, Naveen on 3/31/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize (width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        let title = movie["title"] as! String
        titleLabel.text = title
        let overview = movie["overview"] as! String
        overViewLabel.text = overview
        
        overViewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/original"
        if let filePath = movie["poster_path"] as? String {
            let posterUrl = URL(string: baseUrl + filePath)
            
            moviePoster.setImageWith(posterUrl!)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

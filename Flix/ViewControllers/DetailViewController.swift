//
//  DetailViewController.swift
//  Flix
//
//  Created by Jackson Didat on 1/20/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: CosmosView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    var movie: [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            titleLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            let backdropPathString = movie["backdrop_path"] as! String
            let posterPathString = movie["poster_path"] as! String
            let rating = movie["vote_average"] as! Double
            if let genres = movie["genres"] as? [[String: Any]] {
                for genre in genres {
                    print(genre["name"])
                }
            }
//            let movieID = movie["movie_id"] as! String
//            let movieURL = URL(string: "https://api.themoviedb.org/3/movie/" + movieID + "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
            if let runtime = movie["runtime"] as? Int {
                runtimeLabel.text = String(format: "%d mins.", runtime)
            }
            if let tagline = movie["tagline"] as? String {
                taglineLabel.text = tagline
            }
            ratingLabel.rating = rating
            ratingLabel.settings.fillMode = .precise
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            let posterURL = URL(string: baseURLString + posterPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            posterImageView.af_setImage(withURL: posterURL)
        }
        
        
        // Do any additional setup after loading the view.
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

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
    
    //var movie: [String: Any]?
    var movie: Movie?
    var movie_details: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            let backdropPathString = movie.backdropPathString
            let posterPathString = movie.posterPathString
            let rating = movie.rating
            let id = movie.movieId
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            let posterURL = URL(string: baseURLString + posterPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            posterImageView.af_setImage(withURL: posterURL)
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/" + String(id) + "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let runtime = dataDictionary["runtime"] as? Int {
                        self.runtimeLabel.text = String(format: "%d mins.", runtime)
                    }
                    if let tagline = dataDictionary["tagline"] as? String {
                        self.taglineLabel.text = tagline
                    }
                    let movie_genres = dataDictionary["genres"] as! [[String: Any]]
//                    print(movie_genres)
                    self.genreLabel.text = "";
                    for genre in movie_genres {
                        if let genre = genre["name"] as? String{
                            self.genreLabel.text = self.genreLabel.text! + genre + ", "
                        }
                    }
                    self.genreLabel.text = String(self.genreLabel.text!.dropLast(2))
                }
            }
            
            task.resume()
            ratingLabel.rating = rating
            ratingLabel.settings.fillMode = .precise
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

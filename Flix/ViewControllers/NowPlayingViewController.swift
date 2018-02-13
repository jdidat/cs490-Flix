//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Jackson Didat on 1/14/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import AlamofireImage
import Cosmos
import iTunesSearchAPI

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    let alertController = UIAlertController(title: "Cannot fetch movies", message: "It appears that your internet connection has been lost", preferredStyle: .alert)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //var movies: [[String: Any]] = []
    //var filteredMovies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureiTunes()
        self.searchBar.delegate = self
        filteredMovies = movies
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        fetchMovies()
    }
    
    func configureiTunes() {
        let itunes = iTunes()
        itunes.search(for: "Trolls", ofType: .movie(Entity.movie)) { result in
            // handle the Result<AnyObject, SearchError>
            print("RESULT ")
            print(result)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies: movies.filter { (item: Movie) -> Bool in
            return (item.title as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredMovies != nil { // check for nil
            return self.filteredMovies.count
        }
        else {
            return 0
        }
    }
    
    func fetchMovies() {
        activityIndicator.startAnimating()
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.filteredMovies = self.movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        cell.selectionStyle = .none
        let movie = self.filteredMovies[indexPath.row]
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as! String
//        var rating = movie["vote_average"] as! Double
//        rating = rating / 2.0
//        cell.titleLabel.text = title
//        cell.overviewLabel.text = overview
//        cell.ratingLabel.rating = rating
        cell.ratingLabel.settings.fillMode = .precise
        
        let placeholderURL = URL(string: "https://d32qys9a6wm9no.cloudfront.net/images/movies/poster/500x735.png")!
        cell.posterImageView.af_setImage(withURL: placeholderURL)
        let posterPathString = movie.posterPathString
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
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

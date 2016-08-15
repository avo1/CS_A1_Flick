//
//  MoviesViewController.swift
//  Flick
//
//  Created by Dave Vo on 6/19/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchMovie(.NSUserDefaults)
    }
    
    func fetchMovie(type: DataStorageType) {
        // fetch movie
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 3)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask =
            session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
                
                // If network error?
                guard error == nil else {
                    print("network error")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadData(type)
                        self.tableView.reloadData()
                    }
                    return
                }
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        // print("response: \(responseDictionary)")
                        self.movies = Movie.moviesWithArray(responseDictionary["results"] as! [NSDictionary])
                        self.saveData(type)
                        self.tableView.reloadData()
                    }
                }
                
            })
        task.resume()
    }
    
    func loadData(fromType: DataStorageType) {
        switch fromType {
        case .NSUserDefaults:
            movies = DataManager.loadFromNSUserDefaults()
            
            
            print("load from NSUserDefaults")
        default:
            print("ehhh, where do you want to load the data from?")
        }
    }
    
    func saveData(toType: DataStorageType) {
        switch toType {
        case .NSUserDefaults:
            DataManager.saveToNSUserDefaults(movies)
            print("saved to NSUserDefaults")
            
        default:
            print("unknown type")
        }
    }
    
    @IBAction func onRefresh(sender: UIBarButtonItem) {
        fetchMovie(.NSUserDefaults)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextVC = segue.destinationViewController as! DetailViewController
        
        let ip = tableView.indexPathForSelectedRow
        
        nextVC.movie = movies![ip!.row]
    }
    
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell!
        
        cell.titleLabel.text = movies![indexPath.row].title
        cell.overviewLabel.text = movies![indexPath.row].overview
        cell.posterImage.setImageWithURL(NSURL(string: movies![indexPath.row].posterUrlString)!)
        
        return cell
    }
    
}

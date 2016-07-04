//
//  MoviesViewController.swift
//  Flick
//
//  Created by Dave Vo on 6/19/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [NSDictionary]()
    
    let baseUrl = "https://image.tmdb.org/t/p/w342"
    var selectedImageUrl: String!
    var selectedOverview: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // fetch movie
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask =
            session.dataTaskWithRequest(request,
                                        completionHandler: { (dataOrNil, response, error) in
                                            if let data = dataOrNil {
                                                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                    data, options:[]) as? NSDictionary {
                                                    print("response: \(responseDictionary)")
                                                    self.movies = responseDictionary["results"] as! [NSDictionary]
                                                    self.tableView.reloadData()
                                                }
                                            }
            })
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell!
        //cell.textLabel!.text = (movies[indexPath.row]["title"] as! String)
        cell.titleLabel.text = (movies[indexPath.row]["title"] as! String)
        cell.overviewLabel.text = (movies[indexPath.row]["overview"] as! String)
        
        let posterUrlString = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        
        cell.posterImage.setImageWithURL(NSURL(string: posterUrlString)!)
        
        return cell
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextVC = segue.destinationViewController as! DetailViewController
        
        let ip = tableView.indexPathForSelectedRow
        selectedImageUrl = baseUrl + (movies[ip!.row]["poster_path"] as! String)
        selectedOverview = (movies[ip!.row]["overview"] as! String)
        
        nextVC.overview = selectedOverview
        nextVC.imageUrlString = selectedImageUrl
    }
    
}

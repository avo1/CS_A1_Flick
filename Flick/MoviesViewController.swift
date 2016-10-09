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
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                                        completionHandler: { (dataOrNil, response, error) in
                                            if let data = dataOrNil {
                                                if let responseDictionary = try! JSONSerialization.jsonObject(
                                                    with: data, options:[]) as? NSDictionary {
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell!
        //cell.textLabel!.text = (movies[indexPath.row]["title"] as! String)
        cell?.titleLabel.text = (movies[(indexPath as NSIndexPath).row]["title"] as! String)
        cell?.overviewLabel.text = (movies[(indexPath as NSIndexPath).row]["overview"] as! String)
        
        let posterUrlString = baseUrl + (movies[(indexPath as NSIndexPath).row]["poster_path"] as! String)
        
        cell?.posterImage.setImageWith(URL(string: posterUrlString)!)
        
        return cell!
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextVC = segue.destination as! DetailViewController
        
        let ip = tableView.indexPathForSelectedRow
        selectedImageUrl = baseUrl + (movies[(ip! as NSIndexPath).row]["poster_path"] as! String)
        selectedOverview = (movies[(ip! as NSIndexPath).row]["overview"] as! String)
        
        nextVC.overview = selectedOverview
        nextVC.imageUrlString = selectedImageUrl
    }
    
}

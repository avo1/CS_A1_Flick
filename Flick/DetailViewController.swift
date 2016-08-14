//
//  DetailViewController.swift
//  Flick
//
//  Created by Dave Vo on 6/30/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        posterImage.setImageWithURL(NSURL(string: movie.posterUrlString)!)
        overviewLabel.text = movie.overview
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

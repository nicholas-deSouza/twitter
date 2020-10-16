//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Nicholas de Souza on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetsArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }

    func loadTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParam = ["counts": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam, success: { (tweets: [NSDictionary]) in
            
            self.tweetsArray.removeAll()
            for tweet in tweets{
                self.tweetsArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
        
    }
    
    
    @IBAction func onLogOut(_ sender: Any) {
        
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetsArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetsContent.text = tweetsArray[indexPath.row]["text"] as! String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetsArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetsArray[indexPath.row]["id"] as! Int
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

  
}

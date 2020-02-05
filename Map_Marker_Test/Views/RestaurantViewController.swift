//
//  RestaurantViewController.swift
//  Map_Marker_Test
//
//  Created by Michael Christie on 03/02/2020.
//  Copyright © 2020 Michael Christie. All rights reserved.
//

import UIKit
import Firebase

class RestaurantViewController: UIViewController {
    
    var tableView = UITableView()
    var videos: [Video] = []
    var titles:[String] = []
    var test: [Video] = []
    var imagesOne : UIImage!
    var name : String = ""
    
    struct Cells {
        static let restaurantCell = "restaurantCell"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Your View controller title"
        
        //videos = fetchData()
        
        fetchData { (done) in
            
            if done {
                self.videos = self.test
                self.configureTableView()
            } else {
                // Handle this somehow
            }
        }
        //fetchData()
        //configureTableView()
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        //set delgates and row height
        setDelegates()
        //set row height
        tableView.rowHeight = 130
        
        //register cells
        tableView.register(restaurantCell.self, forCellReuseIdentifier: Cells.restaurantCell)
        //set constraints
        tableView.pin(to: view)
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.restaurantCell) as! restaurantCell
        let video = videos[indexPath.row]
        cell.set(video: video)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    /* func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String?
     {
     
     return "Students"
     }*/
}

extension RestaurantViewController {
    
    
    func fetchData(completion: @escaping (Bool) -> ()){
        
        let db = Firestore.firestore()
        
        db.collection("Restaurants").getDocuments { (snapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in snapshot!.documents {
                    
                    
                    
                    self.name = document.get("Name") as! String
                    
                    //remove the underscore from name
                    let str2 = self.name.replacingOccurrences(of: "_", with: " ", options:
                        NSString.CompareOptions.literal, range: nil)
                    
                    
                    print("New name: ", str2)
                    
                    // do your remaining work
                    let url1 = URL(string: "https://restaurantsspace.s3-eu-west-1.amazonaws.com/\(self.name).jpg")
                    let data1 = try? Data(contentsOf: url1!) //make sure your image in this url does exist
                    
                    self.imagesOne = UIImage(data: data1!)
                    
                    let video1 = Video(image: self.imagesOne,title: str2)
                    
                    self.test.append(video1)
                }
                //self.dowloadPhoto()
                completion(true)
                
            }
        }
    }
}

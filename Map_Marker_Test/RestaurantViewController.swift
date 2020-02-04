//
//  RestaurantViewController.swift
//  Map_Marker_Test
//
//  Created by Michael Christie on 03/02/2020.
//  Copyright © 2020 Michael Christie. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    var tableView = UITableView()
    var videos: [Video] = []
    
    
    struct Cells {
        static let restaurantCell = "restaurantCell"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Local Restaurants"
        videos = fetchData()
        configureTableView()
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        //set delgates and row height
        setDelegates()
        //set row height
        tableView.rowHeight = 100
        
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
        
        return UITableViewCell()
    }
}

extension RestaurantViewController{
    func fetchData() -> [Video]{
        let video1 = Video(image: Images.flipside!,title: "Flipside")
        let video2 = Video(image: Images.belfry!,title: "The Belfry")
        let video3 = Video(image: Images.jalan!,title: "Jalan Jalan")
        let video4 = Video(image: Images.hooked!,title: "Hooked")
        
        return [video1,video2,video3,video4]
    }
}

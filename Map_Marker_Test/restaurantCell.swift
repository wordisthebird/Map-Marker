//
//  restaurantCell.swift
//  Map_Marker_Test
//
//  Created by Michael Christie on 03/02/2020.
//  Copyright © 2020 Michael Christie. All rights reserved.
//

import UIKit

class restaurantCell: UITableViewCell {
    
    var restImageView =  UIImageView()
    var restName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(restImageView)
        addSubview(restName)
        
        configureImageView()
        configureTitleLabel()
        
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(video: Video){
        print("Set")
        restImageView.image = video.image
        restName.text = video.title
    }
    
    func configureImageView(){
        restImageView.layer.cornerRadius = 10
        restImageView.clipsToBounds = true
        //restImageView.contentMode = .scaleAspectFit
    }
    
    func configureTitleLabel(){
        restName.numberOfLines = 0
        restName.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints(){
        restImageView.translatesAutoresizingMaskIntoConstraints = false
        restImageView.contentMode = .scaleAspectFit
        restImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        restImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        restImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        restImageView.widthAnchor.constraint(equalTo: restImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    func setTitleLabelConstraints(){
        restName.translatesAutoresizingMaskIntoConstraints = false
        restName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        restName.leadingAnchor.constraint(equalTo: restImageView.trailingAnchor, constant: 20).isActive = true
        restName.heightAnchor.constraint(equalToConstant: 100).isActive = true
        restName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}

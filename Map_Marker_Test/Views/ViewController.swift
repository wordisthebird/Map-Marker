//
//  ViewController.swift
//  Map_Marker_Test
//
//  Created by Michael Christie on 22/01/2020.
//  Copyright © 2020 Michael Christie. All rights reserved.
//
import Mapbox
import Firebase

class ViewController: UIViewController {
    
    /*override var preferredStatusBarStyle: UIStatusBarStyle {
     return .darkContent
     }*/
    var titles:[String] = []
    private var shouldReloadDataOnViewWillAppear: Bool = true
    let arImage = UIImageView(image: UIImage(named: "logo_pdf")!)
    let splashView = UIView()
    
    var locationsList: [GeoPoint] = []
    var counter = 0
    
    //arrays of names and descriptions
    var names:[String] = []
    var coordinates: [GeoPoint] = []
    var images: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        splashView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        arImage.contentMode = .scaleAspectFit
        splashView.addSubview(arImage)
        arImage.frame = CGRect(x: splashView.frame.midX - 50, y: splashView.frame.midY - 50, width: 100, height: 100)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        if shouldReloadDataOnViewWillAppear {
            // your code for reloading data
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                self.scaleDownAnimation()
            }
            shouldReloadDataOnViewWillAppear = false
        }
        
        //shouldReloadDataOnViewWillAppear = true
        
        
    }
    
    func scaleDownAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.arImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            
        }){ (success) in
            self.scaleUpAnimation()
            
            self.loadDataFromFirebase()
        }
    }
    
    func scaleUpAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn,
                       animations: {
                        self.arImage.transform = CGAffineTransform(scaleX: 50, y: 50)
                        
        }) {(success)in
            self.removeSpashScreen()
        }
    }
    
    func removeSpashScreen(){
        
        splashView.removeFromSuperview()
    }
    
    func loadDataFromFirebase() {
        print("Firebase")
        let db = Firestore.firestore()
        db.collection("Restaurants").getDocuments { (snapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in snapshot!.documents {
                    let name = document.get("Name") as! String

                    let coordinate = document.get("Coordinates") as! GeoPoint
                    
                    self.names.append(name)
                    
                    self.coordinates.append(coordinate)
                    self.locationsList.append(coordinate)
                }
                
                self.secondfunction()
            }
        }
    }
    
    
        
    
    func thirdFunction()
    {
        // Do Stuff
        // Method for displaying map view
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 54.2710154, longitude: -8.4715214)
        mapView.zoomLevel = 15
        mapView.delegate = self
        view.addSubview(mapView)
        
        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in locationsList {
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let point = MGLPointAnnotation()
            point.title = "Tap here for our menu"
            point.coordinate = location
            pointAnnotations.append(point)
        }
        self.tabBarController?.tabBar.isHidden = false
        
        mapView.addAnnotations(pointAnnotations)
        
    }
    
    func secondfunction() {
        //https://mapmarkersspace.s3-eu-west-1.amazonaws.com/belfry.png
        
        for x in names{
            let url1 = URL(string: "https://mapmarkersspace.s3-eu-west-1.amazonaws.com/\(x).png")
            //print("URL: ", url1)
            let data1 = try? Data(contentsOf: url1!) //make sure your image in this url does exist
            //self.imagesOne = UIImage(data: data1!)
            self.images.append(UIImage(data: data1!)!)
        }
        
        self.thirdFunction()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        //goToNext
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
}

extension ViewController: MGLMapViewDelegate {
    
    // MGLMapViewDelegate method for adding static images to point annotations
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annotationImage: MGLAnnotationImage
        print("Problem here: ",names[counter])
        
        let annotationImageCocktail = mapView.dequeueReusableAnnotationImage(withIdentifier: names[counter])
        
        print()
        print("HERE: ",self.names[counter])
        print()
        
        //working one
        //annotationImage = annotationImageCocktail ?? MGLAnnotationImage(image: UIImage(named: "camera")!, reuseIdentifier: "camera")
        let img = images[counter]
        
        //return MGLAnnotationImage(image: img, reuseIdentifier: "car")
        
        annotationImage = annotationImageCocktail ?? MGLAnnotationImage(image: img, reuseIdentifier: names[counter])
        
        counter += 1
        return annotationImage
    }
}



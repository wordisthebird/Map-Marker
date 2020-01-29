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
    
    var locationsList: [GeoPoint] = []
    var locationsNames: [String] = []
    var counter = 0
    
    //arrays of names and descriptions
    var names:[String] = []
    var coordinates: [GeoPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromFirebase()
 
        //secondfunction()
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
                
                for x in self.coordinates{
                    print()
                    print(x.latitude)
                    print()
                }
            }
        }
    }
    
    func secondfunction() {
        // Do Stuff
        // Method for displaying map view
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        /*
         house coords
         54.25875996736305
         -8.458672640917941
         */
        
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 54.2710154, longitude: -8.4715214)
        mapView.zoomLevel = 14
        mapView.delegate = self
        view.addSubview(mapView)
        
        // Specify coordinates for our annotations.
        /*locationsList = [
            
            CLLocationCoordinate2D(latitude: 54.2725555, longitude: -8.4716481),//lillies
            
            CLLocationCoordinate2D(latitude: 54.2710154, longitude: -8.4715214),//belfry
            
            CLLocationCoordinate2D(latitude: 54.27135042736012, longitude: -8.475986924167955),//penneys
            
            //CLLocationCoordinate2D(latitude: 54.25875996736305, longitude: -8.458672640917941)//house
        ]*/

        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in locationsList {
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let point = MGLPointAnnotation()
            point.title = "Click here for our menu"
            point.coordinate = location
            pointAnnotations.append(point)
        }
        
        mapView.addAnnotations(pointAnnotations)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        print("TOuched")
        //goToNext
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
    
}

extension ViewController: MGLMapViewDelegate {
    // MGLMapViewDelegate method for adding static images to point annotations
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
      
        print("Extension: ",counter)
        
        print("Printed: ",names[counter])
        let annotationImage: MGLAnnotationImage
        let annotationImageCocktail = mapView.dequeueReusableAnnotationImage(withIdentifier: names[counter])
        
        annotationImage = annotationImageCocktail ?? MGLAnnotationImage(image: UIImage(named: names[counter])!, reuseIdentifier: names[counter])
        
        counter += 1
        return annotationImage
    }
}



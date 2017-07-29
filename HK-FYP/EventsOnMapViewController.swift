//
//  EventsOnMapViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 21/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class EventsOnMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var manager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var eventNames = [String]()
    var eventGeopoints = [PFGeoPoint]()
    var eventLatitudes = [CLLocationDegrees]()
    var eventLongitudes = [CLLocationDegrees]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = mapView.selectedAnnotations[0].title
        {
            if let selectedEvent = annotationTitle
            {
                //Save selectedEvent to app delegate for future use
                self.appDelegate.clickedMapEvent = selectedEvent
            }
        }
        //Segue to selected pin event details
          performSegue(withIdentifier: "toMapEvent", sender: self)
    }
    
    
    
    override func viewDidLoad()
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.eventGeopoints.removeAll()
        self.eventNames.removeAll()
        self.eventLongitudes.removeAll()
        self.eventLatitudes.removeAll()
        
        //Query all events with geoPoints
        let query = PFQuery(className: "Events")
        query.whereKeyExists("eventGeopoint")
        query.findObjectsInBackground { (objects, error) in
            if error != nil
            {
                print(error ?? "error retrieving geopoints eventsOnMapVC")
            }
            else
            {
                //Loop through objects and retrieve title and eventGeoPoint
                for object in objects!
                {
                    //Append event titles to eventNames array
                    self.eventNames.append(object["title"] as! String)
                    
                    //Append eventGeopoints to eventGeopoints array
                    self.eventGeopoints.append(object["eventGeopoint"] as! PFGeoPoint)
                    self.eventLatitudes.append(self.eventGeopoints.last?.latitude as CLLocationDegrees!)
                    self.eventLongitudes.append(self.eventGeopoints.last?.longitude as CLLocationDegrees!)
                    
                    //Create annotations for event
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(self.eventLatitudes.last!, self.eventLongitudes.last!)
                    annotation.title = self.eventNames.last!
                    self.map.addAnnotation(annotation)
                    self.map.showsUserLocation = true
                }
            }
        }
    }
}

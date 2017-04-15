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
                print(selectedEvent)
                self.appDelegate.clickedMapEvent = selectedEvent
            }
            
        }
    
        
        
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
        
        let query = PFQuery(className: "Events")
        query.whereKeyExists("eventGeopoint")
        query.findObjectsInBackground { (objects, error) in
            if error != nil
            {
                print(error ?? "error")
            }
            else
            {
                
                for object in objects!
                {
                    self.eventNames.append(object["title"] as! String)
                    self.eventGeopoints.append(object["eventGeopoint"] as! PFGeoPoint)
                    self.eventLatitudes.append(self.eventGeopoints.last?.latitude as CLLocationDegrees!)
                    self.eventLongitudes.append(self.eventGeopoints.last?.longitude as CLLocationDegrees!)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(self.eventLatitudes.last!, self.eventLongitudes.last!)
                    annotation.title = self.eventNames.last!
                    self.map.addAnnotation(annotation)
                    self.map.showsUserLocation = true
                }
                print(self.eventGeopoints)
            }
        }

    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

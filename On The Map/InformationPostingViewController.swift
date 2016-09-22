//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/21/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate {
    
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var linkString: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var linkTextView: UITextView!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var prompt: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var geocode: UITextView!
    
    @IBAction func cancel(sender: UIButton) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func findOnTheMap(sender: UIButton) {
        
        if !geocode.text.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(geocode.text, completionHandler: { (placemarks, error) in
                
                if let placemark = placemarks?[0] {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.disableUIs()
                    })
    
                    self.latitude = placemark.location?.coordinate.latitude
                    self.longitude = placemark.location?.coordinate.longitude
                    self.mapString = self.geocode.text
                    
                    //Setup mapview
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
            
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapView.addAnnotation(annotation)
                        self.mapView.centerCoordinate = annotation.coordinate;

                    })

                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.displayAlert("Not a valid address!", message: nil)
                    })
                    
                }
                
            })
        
        } else {
            displayAlert("Enter an address!", message: nil)
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        
        linkString = linkTextView.text
        
        var studentLocation = StudentLocation(uniqueKey: UdacityClient.sharedInstance().currentUser!.uniqueKey! , firstName: UdacityClient.sharedInstance().currentUser!.firstName!, lastName: UdacityClient.sharedInstance().currentUser!.lastName!, mapString: self.mapString!, mediaURL: linkString!, latitude: latitude!, longitude: longitude!)
        
        ParseClient.sharedInstance().newStudentLocation(studentLocation) { (objectId, error) in
            studentLocation.objectId = objectId
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    func disableUIs() {
        
        //Hide prmopt, geocodeTextView, findOnTheMap button.
        prompt.hidden = true
        geocode.hidden = true
        findOnTheMapButton.hidden = true
        
        //Show submitbutton, linkTextView, mapview
        submitButton.hidden = false
        linkTextView.hidden = false
        mapView.hidden = false
        cancelButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)

    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .Default ) { (action) in
            
        }
        
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
}
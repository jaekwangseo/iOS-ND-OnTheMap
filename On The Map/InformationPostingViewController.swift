
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

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var linkString: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var linkTextView: UITextView!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var prompt: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var geocode: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        linkTextView.delegate = self
        geocode.delegate = self
        
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.view.endEditing(true)
    }

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    
    @IBAction func cancel(sender: UIButton) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        
        if !geocode.text.isEmpty {
            let geocoder = CLGeocoder()
            
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
            
            geocoder.geocodeAddressString(geocode.text, completionHandler: { (placemarks, error) in
                
                if let placemark = placemarks?[0] {
                    performUIUpdatesOnMain {
                        self.disableUIs()
                    }
    
                    self.latitude = placemark.location?.coordinate.latitude
                    self.longitude = placemark.location?.coordinate.longitude
                    self.mapString = self.geocode.text
                    
                    //Setup mapview
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
            
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    //Set region zoom
                    let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500_000, 500_000)
                   
                    performUIUpdatesOnMain {
                        self.mapView.addAnnotation(annotation)
                        self.mapView.centerCoordinate = annotation.coordinate;
                        let adjustedRegion = self.mapView.regionThatFits(viewRegion)
                        self.mapView.setRegion(adjustedRegion, animated: true)

                    }

                    
                } else {
                    performUIUpdatesOnMain {
                        self.displayAlert("Geocoding Failed.", message: nil)
                    }
                    
                }
                performUIUpdatesOnMain {
                    self.activityIndicator.alpha = 0.0
                    self.activityIndicator.stopAnimating()
                }

                
            })
        
        } else {
            displayAlert("Enter an address!", message: nil)
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        sender.enabled = false
        
        linkString = linkTextView.text
        
        var studentLocation = StudentLocation(uniqueKey: UdacityClient.sharedInstance.currentUser!.uniqueKey! , firstName: UdacityClient.sharedInstance.currentUser!.firstName!, lastName: UdacityClient.sharedInstance.currentUser!.lastName!, mapString: self.mapString!, mediaURL: linkString!, latitude: latitude!, longitude: longitude!)
        
        // Check whether this user already has a studentlocation.
        if ParseClient.sharedInstance.studentLocation != nil {
            
            //This user already has a studentlocation.
            
            let oldObjectId = ParseClient.sharedInstance.studentLocation?.objectId
            
            ParseClient.sharedInstance.updateStudentLocation(self.presentingViewController, objectId: oldObjectId!, studentLocation: studentLocation, completionHandlerForStudentLocation: { (presentingVC, success, error) in
                
                if success {
                    
                    self.handleSuccessfulUpdate(presentingVC)

                    
                } else {
                    self.handleFailedUpdate(sender)
                }

            })

            
        } else {
            
            //This user does not have a studentlocation.
            
            ParseClient.sharedInstance.newStudentLocation(self.presentingViewController, studentLocation: studentLocation) { (presentingVC, objectId, error) in
                
                if error == nil {
                    
                    studentLocation.objectId = objectId
                    ParseClient.sharedInstance.studentLocation = studentLocation
                    self.handleSuccessfulUpdate(presentingVC)
                } else {
                    self.handleFailedUpdate(sender)
                }
            
            }
        }
        
        
        
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
    
    func handleSuccessfulUpdate(presentingVC: UIViewController?) {
        if let nav = presentingVC as? UINavigationController {
            
            if let tabbarcontroller = nav.childViewControllers[0] as? UITabBarController {
                
                if let map = tabbarcontroller.viewControllers?[0] as? MapViewController {
                    
                    
                    
                    performUIUpdatesOnMain {
                        map.refresh()
                        let coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500_000, 500_000)
                        let adjustedRegion = map.mapView.regionThatFits(viewRegion)
                        map.mapView.setRegion(adjustedRegion, animated: true)
                        map.mapView.centerCoordinate = coordinate
                        
                        self.activityIndicator.alpha = 0.0
                        self.activityIndicator.stopAnimating()
                        
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
    }
    
    func handleFailedUpdate(sender: UIButton) {
        performUIUpdatesOnMain {
            
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
            
            sender.enabled = true
            
            self.displayAlert("Failed", message: "Failed to update student location" )
            //self.dismissViewControllerAnimated(true, completion: nil)
        }

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
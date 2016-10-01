//
//  MapViewController.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/16/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//
//
//  ViewController.swift
//  PinSample
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentViewController?.title = "On The Map"

        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refresh))
        let addButton = UIBarButtonItem(image: UIImage(named: "pin") , style: .Plain, target: self, action: #selector(addMyLocation))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))
        
        parentViewController?.navigationItem.rightBarButtonItems = [refreshButton, addButton]
        parentViewController!.navigationItem.leftBarButtonItem = logoutButton
        
        loadStudentLocations()
        
        self.parentViewController?.navigationItem.rightBarButtonItems![1].enabled = false
        
        //Get public user data
        UdacityClient.sharedInstance.getUserData((UdacityClient.sharedInstance.currentUser?.uniqueKey)!, completionHandlerForUserData: { (success, user, errorString) in
            
            print(user)
            
            UdacityClient.sharedInstance.currentUser?.firstName = user?.firstName
            UdacityClient.sharedInstance.currentUser?.lastName = user?.lastName
            UdacityClient.sharedInstance.currentUser?.uniqueKey = user?.uniqueKey
            
            //TEST
            UdacityClient.sharedInstance.currentUser?.firstName = "Johnny"
            UdacityClient.sharedInstance.currentUser?.lastName = "Depp"
            UdacityClient.sharedInstance.currentUser?.uniqueKey = "TESTKEY3"
            //TEST
            
            //Check if a location exists for this user
            ParseClient.sharedInstance.getStudentLocation((UdacityClient.sharedInstance.currentUser?.uniqueKey)!) { (result, error) in
                
                if result != nil {
                    ParseClient.sharedInstance.studentLocation = result
                } else {
                    ParseClient.sharedInstance.studentLocation = nil
                }
                
                performUIUpdatesOnMain {
                    self.parentViewController?.navigationItem.rightBarButtonItems![1].enabled = true
                }
                
            }
            
        })
        
        
    }
    
    func addMyLocation() {
        
        self.parentViewController?.navigationItem.rightBarButtonItems![1].enabled = false
        
        guard UdacityClient.sharedInstance.currentUser?.uniqueKey != nil else {
            print("addMyLocation error. No userKey exist.")
            return
        }
        
        if ParseClient.sharedInstance.studentLocation != nil {
            let alertController = UIAlertController(title: "Overwrite", message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .Alert)
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default ) { (action) in
                
                //Modally present new student location view
                performUIUpdatesOnMain {
                    
                    self.parentViewController?.navigationItem.rightBarButtonItems![1].enabled = true
                    let postingView = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView")
                    self.presentViewController(postingView, animated: true, completion: nil)
                    
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                
                self.parentViewController?.navigationItem.rightBarButtonItems![1].enabled = true
                
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(overwriteAction)
            
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            let postingView = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView")
            self.presentViewController(postingView, animated: true, completion: nil)
            self.parentViewController?.navigationItem.rightBarButtonItems![1].enabled = true
        
        }
        
        
    }

    
    func loadStudentLocations() {
        ParseClient.sharedInstance.getStudentLocations(100, completionHandlerForStudentLocations: { (studentLocations, error) in
            
            if let studentLocations = studentLocations {
                
                
                SharedData.sharedInstance.studentLocations = studentLocations
                
                // We will create an MKPointAnnotation for each dictionary in "locations". The
                // point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
                
                // The "locations" array is loaded with the sample data below. We are using the dictionaries
                // to create map annotations. This would be more stylish if the dictionaries were being
                // used to create custom structs. Perhaps StudentLocation structs.
                
                for studentLocation in studentLocations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    guard let latitude = studentLocation.latitude, let longitude = studentLocation.longitude else {
                        continue
                    }
                    
                    let lat = CLLocationDegrees(latitude)
                    let long = CLLocationDegrees(longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    if let first = studentLocation.firstName, let last = studentLocation.lastName, let mediaURL = studentLocation.mediaURL {
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                        
                    }
                    
                    
                }
                
                // When the array is complete, we add the annotations to the map.
                
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(annotations)
                    
                    self.activityIndicator.alpha = 0.0
                    self.activityIndicator.stopAnimating()
                }
                
                
            } else {
                print(error)
                
                performUIUpdatesOnMain {
                    
                    self.activityIndicator.alpha = 0.0
                    self.activityIndicator.stopAnimating()
                    
                    self.displayAlert("Couldn't load locations", message: "Couldn't load student information.")
                    
                }
                
                
                
            }
            
        })

    }
    
    func refresh() {
        
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        
        loadStudentLocations()
        
    }
    
    func logout() {
        
        if let selectedVCIsMapVC = tabBarController?.selectedViewController as? MapViewController {
            
            selectedVCIsMapVC.activityIndicator.alpha = 1.0
            selectedVCIsMapVC.activityIndicator.startAnimating()
            
        } else if let selectedVCIsTableVC = tabBarController?.selectedViewController as? TableViewController {
            
            selectedVCIsTableVC.activityIndicator.alpha = 1.0
            selectedVCIsTableVC.activityIndicator.startAnimating()
            
        }
        
        UdacityClient.sharedInstance.logoutSession { (success, errorString) in
            
            if success {
                performUIUpdatesOnMain {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
            } else {
                print("logout failed")
            }
            
            if let selectedVCIsMapVC = self.tabBarController?.selectedViewController as? MapViewController {
                
                selectedVCIsMapVC.activityIndicator.alpha = 0.0
                selectedVCIsMapVC.activityIndicator.stopAnimating()
                
            } else if let selectedVCIsTableVC = self.tabBarController?.selectedViewController as? TableViewController {
                
                selectedVCIsTableVC.activityIndicator.alpha = 0.0
                selectedVCIsTableVC.activityIndicator.stopAnimating()
                
            }
            
        }
    
    }
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                
                guard let url = NSURL(string: toOpen) else {
                    displayAlert("Couldn't open the URL", message: "Couldn't open the URL: \(toOpen)")
                    return
                }
                
                let result = app.openURL(url)
                if !result {
                    displayAlert("Couldn't open the URL", message: "Couldn't open the URL: \(toOpen)")
                }
            }
        }
    }

}
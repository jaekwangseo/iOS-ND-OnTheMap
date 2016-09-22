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
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentViewController?.title = "On The Map"

        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refresh))
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMyLocation))
        
        parentViewController!.navigationItem.rightBarButtonItem = refreshButton
        parentViewController!.navigationItem.leftBarButtonItem = addButton
        
        loadStudentLocations()
        
        //Copy student locations data to TableViewController
        if let tableViewController = self.tabBarController?.viewControllers?[1] as? TableViewController {
            tableViewController.studentLocations = studentLocations
            
            if let tableView = tableViewController.studentLocationTableView {
                tableView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        parentViewController!.navigationItem.leftBarButtonItem?.enabled = true
    }
    
    func addMyLocation() {
        
        parentViewController!.navigationItem.leftBarButtonItem!.enabled = false
        
        guard let userKey = UdacityClient.sharedInstance().currentUser?.uniqueKey else {
            print("addMyLocation error. No userKey exist.")
            return
        }
        
        
        //Check if a location exists for this user
        ParseClient.sharedInstance().getStudentLocation(userKey) { (result, error) in
            
            if result != nil {
                //There is already a studentLocation for this user.
                
                //Show an alert saying there is an already a studentLocation. Prompt for update.
                
                
            } else {
                //There is no studentLocation for this user.
                //Go to create new studentLocation page.
                
                //Get public user data
                UdacityClient.sharedInstance().getUserData((UdacityClient.sharedInstance().currentUser?.uniqueKey)!, completionHandlerForUserData: { (success, user, errorString) in
                    
                    print(user)
                    
                    UdacityClient.sharedInstance().currentUser?.firstName = user?.firstName
                    UdacityClient.sharedInstance().currentUser?.lastName = user?.lastName
                    UdacityClient.sharedInstance().currentUser?.uniqueKey = user?.uniqueKey
                    
                    //Modally present new student location view
                    dispatch_async(dispatch_get_main_queue()) {
                    
                        let postingView = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView")
                        self.presentViewController(postingView, animated: true, completion: nil)
                    }
                    
                })
                
                
            }
        }
    }

    
    func loadStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations(100, completionHandlerForStudentLocations: { (studentLocations, error) in
            
            if let studentLocations = studentLocations {
                
                
                self.studentLocations = studentLocations
                
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addAnnotations(annotations)
                })
                
                
            } else {
                print(error)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.displayAlert("Couldn't load locations", message: "Couldn't load student information.")
                })
                
                
            }
            
        })

    }
    
    func refresh() {
        loadStudentLocations()
        
        //Copy student locations data to TableViewController
        if let tableViewController = self.tabBarController?.viewControllers?[1] as? TableViewController {
            tableViewController.studentLocations = studentLocations
            
            if let tableView = tableViewController.studentLocationTableView {
                tableView.reloadData()
            }
        }

    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default ) { (action) in
            
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
                
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.

}
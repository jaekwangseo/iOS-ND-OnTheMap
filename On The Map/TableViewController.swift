//
//  TableViewController.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/13/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    
    @IBOutlet weak var studentLocationTableView: UITableView!
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance().getStudentLocations(100, completionHandlerForStudentLocations: { (studentLocations, error) in
            
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                dispatch_async(dispatch_get_main_queue(), {
                    self.studentLocationTableView.reloadData()
                })
            } else {
                print(error)
            }
            
        })

    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationTableViewCell"
        let studentLocation = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        if let firstName = studentLocation.firstName, let lastName = studentLocation.lastName {
            cell.textLabel!.text = firstName + " " + lastName
            
        } else {
            cell.textLabel!.text = ""
        }
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)
    }

    
}
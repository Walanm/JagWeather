//
//  WeatherLocationStore.swift
//  JagWeather
//
//  Created by Walan Marcel Teles Oliveira on 2/21/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    var weatherLocationStore: WeatherLocationStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LISTEN FOR NOTIFICATION
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "refreshTable",
            name: "GeolookupResults",
            object: nil)
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        print(WeatherLocationStore.sharedInstance.allLocations.count)
        
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocationStore.allLocations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        // Create or grab a reuseable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        
        // Get an instance of IKEA for the correct location in the table
        let WeatherLocation = weatherLocationStore.allLocations[indexPath.row]
        
        
        cell.textLabel?.text = WeatherLocation.name
        
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "locationDetail" {
            
            let detailVC = segue.destinationViewController as! LocationDetailViewController
            
            if let row = tableView.indexPathForSelectedRow?.row {
                let tappedLocation = WeatherLocationStore.sharedInstance.allLocations[row]
                detailVC.thisLocation = tappedLocation
            }
            
        }
        
    }

    
    
        
    var deleteLocationIndexPath: NSIndexPath? = nil
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteLocationIndexPath = indexPath
            let locationToDelete = weatherLocationStore.allLocations[indexPath.row]
            confirmDelete(locationToDelete)
        }
    }
    
    
    func confirmDelete(location: WeatherLocation) {
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to permanently delete \(location)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteLocation)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteLocation)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func handleDeleteLocation(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteLocationIndexPath {
            tableView.beginUpdates()
            
            weatherLocationStore.allLocations.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteLocationIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteLocation(alertAction: UIAlertAction!) {
        deleteLocationIndexPath = nil
    }
    
    
    

    
    
    
}

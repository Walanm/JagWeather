//
//  WeatherLocationStore.swift
//  JagWeather
//
//  Created by Walan Marcel Teles Oliveira on 2/21/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit

class WeatherLocationStore {
    
    var allLocations = [WeatherLocation]()
    
    static let sharedInstance = WeatherLocationStore()
    
    private init() {
     
        let indianapolis = WeatherLocation(name: "Indianapolis, IN", city: "Indianapolis", state: "IN", country: "US", latitude: 39.77510452, longitude: -86.10947418, elevation: 238.0, zmw: "46201.1.99999")
        
        let austin = WeatherLocation(name: "Austin, TX", city: "Austin", state: "TX", country: "US", latitude: 30.280539, longitude: 97.754555, elevation: 167.0, zmw: "8701.1.99999")
        
        // CODE CHUNK 3:
        // THIS CODE IS PART OF THE INIT FOR WeatherLocationStore AND WILL REQUEST AND DECODE ITEMS OUT OF MEMORY
        
        if let archivedLocations = NSKeyedUnarchiver.unarchiveObjectWithFile(weatherLocationArchiveURL.path!) as? [WeatherLocation] {
            allLocations += archivedLocations
        }
        
        
        //Auto-loading locations
        if allLocations.count < 2 {
            allLocations.append(indianapolis)
            allLocations.append(austin)
        }
        
        
        
    }
    
    // CODE CHUNK 2:
    
    // THIS CODE FINDS THE CORRECT LOCATION IN THE APPLICATION SANDBOX TO STORE ENCODED ITEMS
    
    let weatherLocationArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("weatherlocations.archive")
    }()

    // THIS CODE WILL FORCE THE ITEMS IN MEMORY TO ENCODE WRITE THEMSELVES TO THE APPLICATION SANDBOX
    
    func saveChanges() -> Bool {
        print("Saving items to: \(weatherLocationArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allLocations, toFile: weatherLocationArchiveURL.path!)
    }
    
    
}

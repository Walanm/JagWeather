//
//  WeatherLocationStore.swift
//  JagWeather
//
//  Created by Walan Marcel Teles Oliveira on 2/21/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    var thisLocation: WeatherLocation!
    
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblWind: UILabel!
    @IBOutlet var lblWindDir: UILabel!
    @IBOutlet var lblHumidity: UILabel!
    @IBOutlet var lblFeelsLike: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.startAnimating()
        
        print(thisLocation.city)
        
        APIManager.sharedInstance.retrieveConditionData(thisLocation.zmw)
        
        
        // SET UP OURSELVES AS A LISTENER FOR ConditionResults NOTIFICATION
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateConditions:",
            name: "ConditionResults",
            object: nil)
        
    }
    
    func updateConditions(notification: NSNotification) {
        print("I am going to update conditions now!")
        
        let conditionData:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        
        print(conditionData["temp_f"]!)
        print(conditionData["wind_mph"]!)
        print(conditionData["wind_dir"]!)
        print(conditionData["display_location"]!)
        print(conditionData["feelslike_f"]!)
        print(conditionData["relative_humidity"]!)
        
        lblCity.text = conditionData["display_location"]!
        lblTemp.text = conditionData["temp_f"]!
        lblWind.text = conditionData["wind_mph"]!
        lblWindDir.text = conditionData["wind_dir"]!
        lblFeelsLike.text = conditionData["feelslike_f"]!
        lblHumidity.text = conditionData["relative_humidity"]!

        
        activityIndicator.stopAnimating()
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Check the segue name
        
        if segue.identifier == "locationForecast" {
            
            let forecastViewController = segue.destinationViewController as! ForecastViewController
            
            
            forecastViewController.thisLocation = thisLocation
            
        }
    }
    
    
}

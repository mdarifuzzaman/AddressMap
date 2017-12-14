//
//  MapHelper.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/15/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import Foundation
import MapKit

class MapHelper{
    
    func geoCodeUsingAddress(address:String) ->CLLocationCoordinate2D{
        var latitude = 0.0
        var longitude = 0.0
        let esc_addr = address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let req = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(esc_addr)"
        let result:NSString? = NSString(contentsOfURL: NSURL(string: req));
        //let result:NSString? = NSString(contentsOfURL: NSURL(string: req)), encoding: 1, error: nil)
        if let value=result{
            let scanner:NSScanner = NSScanner(string: value)
            if(scanner.scanUpToString("\"lat\" :", intoString: nil) && scanner.scanString("\"lat\" :", intoString: nil)){
                scanner.scanDouble(&latitude)
            }
            if(scanner.scanUpToString("\"lng\" :", intoString: nil) && scanner.scanString("\"lng\" :", intoString: nil)){
                scanner.scanDouble(&longitude);
            }
        }
        else{
            
        }
        
        var center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        center.latitude = latitude;
        center.longitude = longitude;
        return center;
        
    }
}
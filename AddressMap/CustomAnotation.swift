//
//  CustomAnotation.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/15/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import Foundation
import MapKit

class CustomAnotation:NSObject, MKAnnotation
{
    var coordinate:CLLocationCoordinate2D;
    var title:String;
    var subtitle:String;
    var searchModel:SearchModel?;
    
    init() {
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        self.title = "Dhaka";
        self.subtitle = "Dhaka";
    }
}
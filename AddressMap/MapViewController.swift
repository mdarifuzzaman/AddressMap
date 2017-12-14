//
//  MapViewController.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/15/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import UIKit
import MapKit;

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var _mapCtl: MKMapView
    
    var searchBy:String = "";
    var mapData:SearchModel[]?;
    var customAnotations:CustomAnotation[] = CustomAnotation[]();
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder);
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!)
    {
        for childView:AnyObject in view.subviews{
            childView.removeFromSuperview();
        }
    }
    
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
        if(!view.annotation.isKindOfClass(MKUserLocation)){
            let flyOutView:CustomFlyout = (NSBundle.mainBundle().loadNibNamed("CustomFlyout", owner: self, options: nil))[0] as CustomFlyout;
            var calloutViewFrame = flyOutView.frame;
            calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
            flyOutView.frame = calloutViewFrame;
            
            let customAnotation = view.annotation as CustomAnotation;
            let model = customAnotation.searchModel;
            
            flyOutView.lblTitle.text = model!.name;
            let url = NSURL(string: model!.icon);
            let urlData = NSData(contentsOfURL: url);
            let img = UIImage(data: urlData);
            flyOutView.lblIcon.image = img;
            flyOutView.lblPosition.text = model!.address; //"Longitude: \(model!.lon) & Latitude: \(model!.lat)";
            view.addSubview(flyOutView);
        }
    }
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search By \(searchBy)";
        self._mapCtl.mapType = .Standard;
        self._mapCtl.delegate = self;
        self.customAnotations.removeAll(keepCapacity: false);
        for searchModel in self.mapData!{
            let customAnotation = CustomAnotation()
            customAnotation.coordinate = CLLocationCoordinate2D(latitude: searchModel.lat, longitude: searchModel.lon);
            customAnotation.title = "";
            customAnotation.subtitle = ""
            customAnotation.searchModel = searchModel;
            self.customAnotations.append(customAnotation)
        }
        
        self.zoomToFitMapAnnotations();
       
    }
    
    
    func zoomToFitMapAnnotations(){
        var topLeftCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        var bottomRightCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        var foundAnotation = false;
        
        for anotation in self.customAnotations{
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, anotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, anotation.coordinate.latitude);
            
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, anotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, anotation.coordinate.latitude);
            
            self._mapCtl.addAnnotation(anotation);
            foundAnotation = true;
        }
        
        if(!foundAnotation){
            return;
        }
        
        var region:MKCoordinateRegion = MKCoordinateRegion(center: topLeftCoord, span:MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0));
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
        self._mapCtl.regionThatFits(region);
        self._mapCtl.setRegion(region, animated: true);

    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

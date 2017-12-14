//
//  ViewController.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/15/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let apiKey = "AIzaSyCRTPt0M4d9-26B_MsGLDeTJXdpjlk7hdE"
    let mapHelper:MapHelper = MapHelper();
    var autoCompleteTableView:UITableView;
    var autoCompleteDataSource:Array<String> = [];
    var mapData:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var searchBy:String = ""
    
    init(coder aDecoder: NSCoder!) {
        autoCompleteTableView = UITableView(frame: CGRectMake(13, 200, 295, 200), style: UITableViewStyle.Plain);
        super.init(coder: aDecoder);
    }
    
    @IBOutlet var txtSearch: UITextField
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self;
        NSNotificationCenter.defaultCenter()?.addObserver(self, selector: Selector("dataLoaded:"), name: "DataLoaded", object: nil);
        autoCompleteTableView.dataSource = self;
        autoCompleteTableView.delegate = self;
        autoCompleteTableView.backgroundColor = UIColor.clearColor();
        autoCompleteTableView.separatorColor = UIColor.clearColor();
        
        autoCompleteDataSource.append("Restaurant");
        autoCompleteDataSource.append("Airport");
        autoCompleteDataSource.append("Atm");
        autoCompleteDataSource.append("Bank");
        autoCompleteDataSource.append("Curch");
        autoCompleteDataSource.append("Hospital");
        autoCompleteDataSource.append("Mosque");
        autoCompleteDataSource.append("Movie_theater");
        autoCompleteTableView.hidden = true;
        
        self.view.addSubview(autoCompleteTableView);
        
       
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        //autoCompleteTableView.hidden = true;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
        searchBy = self.autoCompleteDataSource[indexPath.row];
        let searchkey = self.autoCompleteDataSource[indexPath.row].lowercaseString;
        
        let serviceHelper = ServiceHelper();
        let dynamicURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(mapData.latitude),\(mapData.longitude)&radius=5000&types=\(searchkey)&sensor=true&key=\(apiKey)"
        print(dynamicURL);
        serviceHelper.getServiceHandle(self.dataLoaded, url: dynamicURL);

    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return self.autoCompleteDataSource.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var cell:UITableViewCell?;
        let cellString = "autocompletecell";
        if let cellToUse = cell{
            
        }
        else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellString);
        }
        
        let data = autoCompleteDataSource[indexPath.row];
        var img:UIImage?;
        
        if(data == "Restaurant"){
            img = UIImage(named: "restaurent.jpg");
            
        }
        else if(data == "Airport"){
            img = UIImage(named: "airport.png");
        }
        else if(data == "Hospital"){
            img = UIImage(named: "hospital.png");
        }
        else if(data == "Mosque"){
            img = UIImage(named: "mosque.png");
        }
        else if(data == "Curch"){
            img = UIImage(named: "church-icon.png");
        }
        else if(data == "Atm"){
            img = UIImage(named: "atm.png");
        }
        else if(data == "Bank"){
            img = UIImage(named: "bank.png");
        }
        else if(data == "Movie_theater"){
            img = UIImage(named: "cinema.png");
        }
        else{
            img = UIImage(named: "noimage.gif");
        }
        
        
        cell!.imageView.image = img!;
        cell!.textLabel.text = data;
        cell!.backgroundColor = UIColor(red: 100, green: 100, blue: 190, alpha: 0.5);
        
        
        return cell!;
    }
    
    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
     func textFieldShouldReturn(textField: UITextField!) -> Bool{
        txtSearch.resignFirstResponder();
        self.doSearch()
        return true;
    }
    
    
    func doSearch(){
        
       dispatch_async(dispatch_get_main_queue()){
            let searchText = self.txtSearch.text.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
            if(searchText.isEmpty){
                return;
            }
            
            self.mapData =  self.mapHelper.geoCodeUsingAddress(searchText);
            if(self.mapData.latitude <= 0.0 && self.mapData.longitude <= 0.0){
                var alert = UIAlertController(title: "Warning", message: "Unable to find any location", preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
                self.autoCompleteTableView.hidden = true;
                return;
            }
        self.autoCompleteTableView.hidden = false;
            
            
           
       }
        
    }
    
    func dataLoaded(userData:SearchModel[]){
        //print(userData);
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let mapController:MapViewController = storyBoard.instantiateViewControllerWithIdentifier("mapViewController") as MapViewController;
        mapController.mapData = userData;
        mapController.searchBy = self.searchBy;
        self.navigationController.pushViewController(mapController, animated: true);
        
    }
    
}


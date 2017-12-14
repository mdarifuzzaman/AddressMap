//
//  ServiceHelper.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/16/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import Foundation
class ServiceHelper{
    
    
    
    func getServiceHandle(afterDownload:(SearchModel[]) -> Void ,url:String){
        
        let nsURL:NSURL = NSURL(string: url);
        print(url);
        let urlRequest = NSMutableURLRequest(URL: nsURL);
        urlRequest.timeoutInterval = 30.0;
        urlRequest.HTTPMethod = "GET";
        let queue:NSOperationQueue = NSOperationQueue.mainQueue();
        
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: { response, data, error in
            print(response);
            print(data);
            if(data.length > 0){
                var publishData:SearchModel[] = SearchModel[]();
                var errorPointer:NSError?
                let jsonObject:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &errorPointer);
                print(jsonObject);
                if(jsonObject.isKindOfClass(NSDictionary)){
                    
                    let jsonData = jsonObject as NSDictionary;
                    let datas =  jsonObject.valueForKey("results")! as NSArray;
                    
                    for dictData : AnyObject in datas{
                        let dictEach = dictData as NSDictionary;
                        let name = dictEach.valueForKey("name")! as NSString;
                        let icon = dictEach.valueForKey("icon")! as String;
                        
                        print(name);
                        print(icon);
                        
                        let gematries = dictEach.valueForKey("geometry")! as NSDictionary;
                        let locations:AnyObject = gematries.valueForKey("location")!;
                        let lon = locations.valueForKey("lng")! as Double;
                        let lat = locations.valueForKey("lat")! as Double;
                        
                        let address = dictEach.valueForKey("vicinity")! as String;
                        
                        var searchModel:SearchModel = SearchModel(name: name, icon: icon, lon: lon, lat: lat,address:address);
                        publishData.append(searchModel);
                        
                        
                    }
                    print(publishData);
                    for  item in publishData{
                        print(item.name);
                        print(item.icon);
                        print(item.lat);
                        print(item.lon);
                    }
                    afterDownload(publishData);
                    //block(publishData);
                    //NSNotificationCenter.defaultCenter()?.postNotificationName("DataLoaded", object: nil, userInfo: ["data":publishData]);
                }
            }
            else{
                    //error cought here
            }
            
        });
        //completionHandler: ((response:NSURLResponse!, data:NSData!, error:NSError!), -> Void)
        
    }
}
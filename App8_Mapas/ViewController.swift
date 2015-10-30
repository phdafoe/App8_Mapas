//
//  ViewController.swift
//  App8_Mapas
//
//  Created by User on 30/10/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation




class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - VARIABLES LOCALES
    var locationManager = CLLocationManager()
    
    //MARK: - IB
    @IBOutlet weak var myFirstMap: MKMapView!
    

    //MARK: - LYFE APP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fase 1 ->
        
        let latitude : CLLocationDegrees = 40.4
        let longitude : CLLocationDegrees = -3.7
        let latDelta : CLLocationDegrees = 0.01
        let longDelta : CLLocationDegrees = 0.01
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myFirstMap.setRegion(region, animated: true)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


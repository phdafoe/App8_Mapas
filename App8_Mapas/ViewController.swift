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
        
        
        // Fase 3 -> Añadir una chincheta
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Madrid"
        annotation.subtitle = "Hey estamos Aqui!"
        
        myFirstMap.addAnnotation(annotation)*/
        
        // Fase 4 -> Gesto del Dedo
        
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "actionGesture:")
        longGestureRecognizer.minimumPressDuration = 2
        myFirstMap.addGestureRecognizer(longGestureRecognizer)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - DELEGATE
    // Fase 2 -> Actualizacion de la localizacion con el delegado
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation : CLLocation = locations[0] as CLLocation
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta : CLLocationDegrees = 0.01
        let longDelta : CLLocationDegrees = 0.01
        
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myFirstMap.setRegion(region, animated: true)
        
        
    }
    
    
    //MARK: - UTILS
    // Fase 4 -> Metodo Auxuliares
    func actionGesture(gestureRecognizer: UIGestureRecognizer){
        
        let touchPoint = gestureRecognizer.locationInView(self.myFirstMap)
        let newCoordinate : CLLocationCoordinate2D = myFirstMap.convertPoint(touchPoint, toCoordinateFromView: self.myFirstMap)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Madrid"
        annotation.subtitle = "Hey aqui estamos"
        
        myFirstMap.addAnnotation(annotation)
        
    }


}


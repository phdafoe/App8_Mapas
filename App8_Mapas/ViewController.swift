//
//  ViewController.swift
//  App8_Mapas
//
//  Created by User on 30/10/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit
//MARK: - FRAMEWORK
import MapKit
//Este framework sirve basicamente para acceder al GPS del dispositivo
import CoreLocation

//las enumeraciones  definene un grupo de valores relacionados, nos permiten trabajar de una forma mas segura
//podemos concatenar case siempre que sean del mismo tipo
/*enum NombresFamiliaSalamanca : String{
    case Andres
    case Felipe
    case Ocampo
    case Eljaiek
    case Arturo, Felipee, OOcampo, EEljaiek
}*/

enum MapType : Int{
    case Standard = 0
    case Hibrido = 1
    case Satellite = 2
}


class ViewController: UIViewController{
    
    //MARK: - VARIABLES LOCALES
    //FASE 5 ->
    //Aquí es donde inicializamos nuestra CLLocationManager . Básicamente, este tipo es responsable de saber dónde estamos en todo momento ... físicamente. Utilizamos un delegado para que podamos tomar ventaja de una función que es llamada cada vez que nuestra ubicación se actualiza:
    var locationManager = CLLocationManager()
    
    
    //MARK: - IBOUTLET
    @IBOutlet weak var myFirstMap: MKMapView!
    @IBOutlet weak var mySegmentControlSC: UISegmentedControl!
    @IBOutlet weak var myLabel: UILabel!
    
    //MARK: - IBACTION
    
    @IBAction func showMapBTN(sender: AnyObject) {
        
        
        // FASE 1 ->
        // VAmos a crearnos un punto en el mapa y le vamos a decri que queremos ese punto como centro de nuestro mapa
        let latitude : CLLocationDegrees = 40.433667 //N
        let longitude : CLLocationDegrees = -3.676266 //E
        
        //Cuando usamos la palabra Delta es por que nos referimos a una diferencia, y esto exactamente nos dice que le vamos a pedir cual es nuestro campo de vision dentro de nuestro mapa, es decir, cuantos grados quiero estar viendo dentro de mi mapa, es una cifra muy pequeña, tanto en vertical "latitud" como en horizontal "longitud", lo que concluye que se use como e zoom de trabajo del mapa
        let latDelta : CLLocationDegrees = 0.01
        let longDelta : CLLocationDegrees = 0.01
        
        //Vamos a definir la localizacion de un punto construyento un objeto del tipo "CLLocationCoordinate2D"
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        //una variable span que es a la que le dire que tenga encuenta estos dos valores del tipo "DELTA"
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //Definimos la Region que nos pide dos dataos, una posicion en el mapa y un zoom de visualizacion
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myFirstMap.setRegion(region, animated: true)

        
        // Fase 3 -> Añadir una chincheta
        //MKAnnotation es un tipo especifico de objeto para crear anotaciones
        let annotation = MKPointAnnotation()
        //me pide la coordenada de esa chincheta (location)
        annotation.coordinate = location
        annotation.title = "Madrid"
        annotation.subtitle = "Hey estamos Aqui!"
        
        myFirstMap.addAnnotation(annotation)
        
        
        
        
        
        // Fase 4 -> Gesto del Dedo (pulsacion larga / LongPress de Android)
        //PATRON TARGET / ACTION
        //le pasamos dos cosas 1 donde esta el metodo y como se llama este metodo, funcion, selector, accion
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "actionGesture:")
        longGestureRecognizer.minimumPressDuration = 2
        myFirstMap.addGestureRecognizer(longGestureRecognizer)
  
        
    }
    
    
    @IBAction func myTypeChenged(sender: AnyObject) {
        
        let mapType = MapType(rawValue: mySegmentControlSC.selectedSegmentIndex)
        
        switch (mapType!){
            
        case.Standard:
            myFirstMap.mapType = MKMapType.Standard
        case.Hibrido:
            myFirstMap.mapType = MKMapType.Hybrid
        case.Satellite:
            myFirstMap.mapType = MKMapType.Satellite
            break
        }
    }
    

    //MARK: - UTILS
    // Fase 4.1 -> Cuando inicializamos el GestureRecognizer y se lo pasamos como nuevo metodo de la action debemos colocarle como parametro de entrada o argumento el propio GestureRecognizer
    func actionGesture(gestureRecognizer: UIGestureRecognizer){
        
        //Punto de toche es decir el parametro de medida en que parte de mi interfaz se ha pulsado con el dedo y ademas con una espera maxima de 2 segundos ademas lo que yo quiero es que esa posicion en la vista debe ser una coordenada en mi mapa
        let touchPoint = gestureRecognizer.locationInView(myFirstMap)
        
        //este objeto el CLLocationCoordinate2D tiene metodos, inicilaizadores, funcion  y lo que quiero es coveertir mi toque de punto en la pantalla en una coordenada de mi mapa
        let newCoordinate : CLLocationCoordinate2D = myFirstMap.convertPoint(touchPoint, toCoordinateFromView: myFirstMap)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "CICE hemos creado Anotacion"
        annotation.subtitle = "estamos :)"
        
        myFirstMap.addAnnotation(annotation)
        
    }
    

    //MARK: - LIFE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fase 5 -> OJO
        
        // Solicitud de Autorizacion al Usuario // Info.plist NSLocationWhenInUseUsageDescription -> es el texto que le solicita el Dispositivo al usuario Si desea acceder al GPS del Dispositivo  (Por que necesito saber donde estas)
        
        // NSLocationAlwaysUsageDescription -> basicamente le doy permiso a la App para siempre sepa donde esta el GPS, incluso cuando esta en SegundoPlano

        //Fase de precision  es un numero
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        //Fase de  autorizacion
        locationManager.requestWhenInUseAuthorization()
        
        //Por último, llamamos manager.startUpdatingLocation () que en realidad comienza a comprobar si cambiamos ubicaciones o no. Si cambiamos lugares, se llamará:
        locationManager.startUpdatingLocation()


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




//MARK: - DELEGATE CLLocationManagerDelegate
//Detecta nuevas posiciones del GPS  cuando el usuario se haya movido
extension ViewController : CLLocationManagerDelegate{
    
    
    // Fase 2 -> Actualizacion de la localizacion con el delegado
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print(locations)
        //Esto es una simulacion predeterminada, es bueno pues no estoy usando un dispositivo real
        //Vamos a mover el mapa segun cambie la posicion o localizacion del usuario
        
        
        //Me devuelve un Array  de echo desde las ultimas (moderna) hasta las primeras (antiguas) posiciones
        //el inicio en este caso es que quiero que me de la primera posicion
        
        //Centramos la posicion del usuario utilizando el GPS (simulador)
        //let userLocation = locations[0]
        let userLocation = locations.first!
        
        let latitud = userLocation.coordinate.latitude
        let longitud = userLocation.coordinate.longitude
        
        //Cuando usamos la palabra Delta es por que nos referimos a una diferencia, y esto exactamente nos dice que le vamos a pedir cual es nuestro campo de vision dentro de nuestro mapa, es decir, cuantos grados quiero estar viendo dentro de mi mapa, es una cifra muy pequeña, tanto en vertical "latitud" como en horizontal "longitud", lo que concluye que se use como e zoom de trabajo del mapa
        let latDelta : CLLocationDegrees = 0.01
        let longDelta : CLLocationDegrees = 0.01
        
        //Vamos a definir la localizacion de un punto construyento un objeto del tipo "CLLocationCoordinate2D"
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitud, longitud)
        
        //una variable span que es a la que le dire que tenga encuenta estos dos valores del tipo "DELTA"
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //Definimos la Region que nos pide dos dataos, una posicion en el mapa y un zoom de visualizacion
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myFirstMap.setRegion(region, animated: true)
        myLabel.text = "\(userLocation)"
        
        
        
        //====================********===========//

        /*let userLocation = locations.first! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.myFirstMap.setRegion(region, animated: true)
        
        
        // Add an annotation on Map View
        let point: MKPointAnnotation! = MKPointAnnotation()
        point.coordinate = userLocation.coordinate
        point.title = "Nueva Localizacion"
        point.subtitle = "mas detalles"
        
        self.myFirstMap.addAnnotation(point)
        
        //stop updating location to save battery life
        //locationManager.stopUpdatingLocation()*/
   
    }
    
    
    
    
}


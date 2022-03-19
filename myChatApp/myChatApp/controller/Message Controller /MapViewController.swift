//
//  LocationViewController.swift
//  myChatApp
//
//  Created by Eslam Ali  on 16/03/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

 //MARK:- Vars
    var location : CLLocation?
    var mapView : MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Location View "

        configureMapView()
        configureBackButton()
}
    
    override func viewWillAppear(_ animated: Bool) {
        // hide tabbar 
    }


    private func configureMapView () {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: view.frame.size.height))
        mapView.showsUserLocation = true
        if location != nil {
            mapView.setCenter(location!.coordinate, animated: false)
            mapView.addAnnotation(MapAnnotation(title: "User Location", coordinate: location!.coordinate))
            
            
            
        }
        view.addSubview(mapView)
    }
    
    private func configureBackButton(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle(" Back", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    
    }
    
    
    @objc func didTapBackButton(){

        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    

}

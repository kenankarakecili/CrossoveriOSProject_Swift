//
//  MapVC.swift
//  Saitama
//
//  Created by Kenan Karakecili on 2/07/2016.
//  Copyright © 2016 Kenan Karakecili. All rights reserved.
//

import UIKit
import GoogleMaps

struct PlaceStruct {
  let id: String
  let name: String
  let latitude: String
  let longitude: String
}

class MapVC: BaseVC {
  
  @IBOutlet weak var navigationButton: UIButton!
  var mapView: GMSMapView?
  var places: [PlaceStruct] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.titleView = UIImageView(image: imgLogo)
    addNotificationObservers()
    setupGoogleMaps()
    callWebService()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func addNotificationObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(callWebService), name: kReachabilityChangedNotification, object: nil)
  }
  
  func setupGoogleMaps() {
    mapView = GMSMapView(frame: CGRectZero)
    let camera = GMSCameraPosition.cameraWithLatitude(35.900006, longitude: 139.649440, zoom: 11)
    mapView!.camera = camera
    mapView!.myLocationEnabled = true
    mapView!.delegate = self
    view = mapView
  }
  
  func callWebService() {
    if !User.isLogin() { return }
    showLoading(true)
    MapAPI.requestPlaces { (placeItems) in
      showLoading(false)
      self.places = placeItems
      self.addMarkers()
    }
  }
  
  func addMarkers() {
    for place in places {
      let position = CLLocationCoordinate2DMake(CLLocationDegrees(place.latitude)!,
                                                CLLocationDegrees(place.longitude)!)
      let marker = GMSMarker(position: position)
      marker.title = place.name
      marker.icon = UIImage(named: "img-marker")
      marker.infoWindowAnchor = CGPointMake(marker.infoWindowAnchor.x, 0.35)
      marker.map = mapView
    }
  }
  
  @IBAction func centerMapToUser(sender: UIButton) {
    if let myCoordinate = mapView?.myLocation?.coordinate {
      mapView?.animateToLocation(myCoordinate)
    }
  }
  
}

extension MapVC: GMSMapViewDelegate {
  
  func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    let markerView = MarkerView.instanceFromNib()
    markerView.setup(marker.title!)
    return markerView
  }
  
  func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
    performSegueWithIdentifier("MapVC_to_PaymentVC", sender: nil)
  }
  
}

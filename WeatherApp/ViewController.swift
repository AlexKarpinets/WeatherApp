//
//  ViewController.swift
//  WeatherApp
//
//  Created by Karpinets Alexander on 20.12.2021.
//

import Alamofire
import CoreLocation
import NVActivityIndicatorView
import SwiftyJSON
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    private let gradientLayer = CAGradientLayer()
    
    private let apiKey = "acbfe93e782f1a17ab4a98e10aee9b34"
    private var lat = 62.424824
    private var lon = 40.174954
    private var activityIndicator: NVActivityIndicatorView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.width-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueBackground()
    }
    
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location = locations[0]
      lat = location.coordinate.latitude
      lon = location.coordinate.longitude
      
      let request = AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")
      
      request.responseDecodable { _ in
          self.activityIndicator.stopAnimating()
          if let responseStr = response.result.value {
              let jsonResponse = JSON(responseStr)
              let jsonWeather = jsonResponse["Weather"].array[0]
              let jsonTemp = jsonResponse["main"]
              let iconName = jsonWeather["icon"].stringValue
          }
      }
    }
    
    private func setBlueBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    private func setGreyBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    
}


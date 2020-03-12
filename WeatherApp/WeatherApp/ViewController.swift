//
//  ViewController.swift
//  WeatherApp
//
//  Created by MacBook on 24/09/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperaureLabel: UILabel!
    @IBOutlet weak var apparantTemperatureLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    lazy var weatherManager = APIWeatherManager(apiKey: "d101880b3e28fa88e134de7cd1cf9322")
    let cordinates = Coordinates(latitude: 37.8267, longitude: 122.4233)
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        getCurrentWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        print("my location latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }
    
    fileprivate func getCurrentWeatherData() {
        weatherManager.fetchCurrentWeatherWith(coordinates: cordinates) { (result) in
            self.toggleActivityIndicator(on: false)
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                self.vcError(title: "Unable to get data", message: "\(error.localizedDescription)", error: error)
            }
        }
    }
    
    func vcError(title: String, message: String, error: NSError){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac,animated: true, completion:  nil)
    }
    func updateUIWith(currentWeather: CurrentWeather){
        self.weatherImage.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperaureLabel.text = currentWeather.temperatureString
        self.apparantTemperatureLabel.text = currentWeather.appearantTemperatureString
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    
    func toggleActivityIndicator(on: Bool){
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}




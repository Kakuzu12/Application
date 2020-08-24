//
//  ViewController.swift
//  Weather_app
//
//  Created by Егор on 25.07.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let networkManager = WeatherNetworkManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var sampleVariable: WeatherModel?
    var deletionCheck: [Any] = ["",true]
    
    let currentLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(backwardTransition), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    let tempDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    let tempSymbol: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    
    
    let maxTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    let minTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "ViewController"
        
        self.navigationItem.rightBarButtonItems = [createBarItems()[0], createBarItems()[1]]
        
        transparentNavigationBar()
        
        setupViews()
        layoutViews()
    }
    
    func createBarItems() -> [UIBarButtonItem] {
        let thermometerButton = UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handleShowForecast))
        thermometerButton.accessibilityIdentifier = "thermometerButton"
        let arrowButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        arrowButton.accessibilityIdentifier = "arrowButton"
        return [thermometerButton,arrowButton]
    }
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            self.appDelegate.saveWeatherEntity(model: weather)
            self.sampleVariable = weather
            print("Current Temperature is", weather.main.temp.kelvinToCeliusConverter())
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy" //yyyy
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                self.tempSymbol.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            print("Current Temperature was", weather.main.temp.kelvinToCeliusConverter())
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy" //yyyy
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                self.tempSymbol.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    func setupViews() {
        view.addSubview(deleteButton)
        view.addSubview(currentLocation)
        view.addSubview(currentTemperatureLabel)
        view.addSubview(tempSymbol)
        view.addSubview(tempDescription)
        view.addSubview(currentTime)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
        currentLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        currentLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        currentLocation.heightAnchor.constraint(equalToConstant: 70).isActive = true
        currentLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 4).isActive = true
        currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        currentTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        currentTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        currentTemperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        currentTemperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        currentTemperatureLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        currentTemperatureLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        tempSymbol.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor).isActive = true
        tempSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tempSymbol.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tempSymbol.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempDescription.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 12.5).isActive = true
        tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor, constant: 8).isActive = true
        tempDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tempDescription.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: 80).isActive = true
        minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        minTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor).isActive = true
        maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        maxTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    //MARK: - Handlers
    
    @objc func backwardTransition() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShowForecast() {
        self.navigationController?.pushViewController(ForecastViewController(), animated: true)
    }
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
    
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
    }
    
}

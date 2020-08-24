//
//  TableViewAdd.swift
//  Weather_app
//
//  Created by Егор on 24.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewAdd: UIViewController, CLLocationManagerDelegate {
    
    let networkManager = WeatherNetworkManager()
    var models: [TableViewCellModel]? = []
    var locationManager = CLLocationManager()
    
    private enum Locals {
        static let cellID = "cell"
    }
    
    var cellHeight: CGFloat = 70
    var numberOfSections: Int = 1
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = setupButton()
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "Write down your city", preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = "alert"
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
            textField.accessibilityIdentifier = "textField"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("City Name: \(String(describing: firstTextField.text))")
            guard let cityname = firstTextField.text else { return }
            //let instanceViewController: ViewController? = ViewController()
           // instanceViewController?.loadData(city: cityname)
            self.loadData(city: cityname)
            print("Number is \(String(describing: self.models?.count))")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadData(city: String){
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            print("Current Temperature are", weather.main.temp.kelvinToCeliusConverter())
            DispatchQueue.main.async {
            self.models?.append(TableViewCellModel(name: weather.name ?? "", country: weather.sys.country ?? ""))
            self.tableView.reloadData()
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            print("Current Temperature were", weather.main.temp.kelvinToCeliusConverter())
            DispatchQueue.main.async {
                self.models?.append(TableViewCellModel(name: weather.name ?? "", country: weather.sys.country ?? ""))
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        print("Long", longitude.description)
        print("Lat", latitude.description)
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        //tableView.frame = CGRect(x: 95, y: 230, width: self.view.frame.size.width/2, height: self.view.frame.size.width/2-50)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            //tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            tableView.heightAnchor.constraint(equalToConstant: 200),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Locals.cellID)
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        tableView.layer.borderWidth = 2.0
    }
    
    func setupButton() -> UIBarButtonItem{
        let plusCircleButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton))
        plusCircleButton.accessibilityIdentifier = "plusCircleButton"
        return plusCircleButton
    }
}


//MARK: - TableViewConfiguration
extension TableViewAdd: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Locals.cellID, for: indexPath)
        cell.textLabel?.text = models![indexPath.row].nameValue + ", " + models![indexPath.row].countryValue
        if indexPath.row == 0{
            cell.backgroundColor = .lightGray
        } else{
            cell.backgroundColor = .white
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController: ViewController = ViewController()
        print(" Hello world \(models![indexPath.row].nameValue)")
        viewController.loadData(city: models![indexPath.row].nameValue)
        self.navigationController?.pushViewController(viewController,animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row == 0){
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) && (indexPath.row != 0){
            tableView.beginUpdates()
            models?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
            tableView.endUpdates()
        }
        
    }
    
}



//
//  WeatherModelConverter.swift
//  Weather_app
//
//  Created by Егор on 10.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit
import CoreData

protocol WeatherModelConverterInput {
    func convert(weatherModel: WeatherModel,completion: @escaping ((WeatherEntity) -> WeatherEntity))
    func convertWeather(weatherModel: Weather,completion: @escaping ((DetailedWeatherEntity) -> DetailedWeatherEntity))
}

public class WeatherModelConverter {
    var appDelegate: AppDelegate!
}

extension WeatherModelConverter: WeatherModelConverterInput {
    
    func convert(weatherModel: WeatherModel,completion: @escaping ((WeatherEntity) -> WeatherEntity)) {
        DispatchQueue.main.async{
            self.appDelegate = UIApplication.shared.delegate as? AppDelegate
            let entity = WeatherEntity.init(entity: NSEntityDescription.entity(forEntityName: "WeatherEntity", in:self.appDelegate.persistentContainer.viewContext)!, insertInto:self.appDelegate.persistentContainer.viewContext)
            entity.dt = weatherModel.dt
            entity.country = weatherModel.sys.country
            entity.dt_txt = weatherModel.dt_txt
            entity.feels_like = weatherModel.main.feels_like
            entity.humidity = weatherModel.main.humidity
            entity.name = weatherModel.name
            entity.pressure = weatherModel.main.pressure
            entity.sunrise = weatherModel.sys.sunrise ?? 0
            entity.sunset = weatherModel.sys.sunset ?? 0
            entity.temp = weatherModel.main.temp
            entity.temp_max = weatherModel.main.temp_max
            entity.temp_min = weatherModel.main.temp_min
            entity.timezone = weatherModel.timezone ?? 0
            completion(entity)
        }
        
    }
    func convertWeather(weatherModel: Weather,completion: @escaping ((DetailedWeatherEntity) -> DetailedWeatherEntity)) {
        DispatchQueue.main.async{
            self.appDelegate = UIApplication.shared.delegate as? AppDelegate
            let entity = DetailedWeatherEntity.init(entity: NSEntityDescription.entity(forEntityName: "DetailedWeatherEntity", in:self.appDelegate.persistentContainer.viewContext)!, insertInto:self.appDelegate.persistentContainer.viewContext)
            entity.id = weatherModel.id
            entity.icon = weatherModel.icon
            entity.definition = weatherModel.description
            entity.main = weatherModel.main
            completion(entity)
        }
    }
}



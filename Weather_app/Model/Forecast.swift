//
//  Forecast.swift
//  Weather_app
//
//  Created by Егор on 03.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit

struct WeatherInfo {
    let temp: Float
    let min_temp: Float
    let max_temp: Float
    let description: String
    let icon: String
    let time: String
}

struct ForecastTemperature {
    let weekDay: String?
    let hourlyForecast: [WeatherInfo]?
}

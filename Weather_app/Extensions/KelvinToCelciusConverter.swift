//
//  KelvinToCelciusConverter.swift
//  Weather_app
//
//  Created by Егор on 03.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit

extension Float {
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places))) //оставляем только places знаков после запятой
    }
    
    func kelvinToCeliusConverter() -> Float {
        let constantVal : Float = 273.15
        let kelValue = self
        let celValue = kelValue - constantVal
        return celValue.truncate(places: 1) //переводим в цельсии из кельвинов
    }
}

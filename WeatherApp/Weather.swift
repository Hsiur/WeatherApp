//
//  Weather.swift
//  WeatherApp
//
//  Created by Ruslan Ishmukhametov on 10.11.2021.
//

import Foundation


public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}

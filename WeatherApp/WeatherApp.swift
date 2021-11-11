//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Ruslan Ishmukhametov on 10.11.2021.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            WeatherView(viewModel: viewModel)
        }
    }
}

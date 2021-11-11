//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Ruslan Ishmukhametov on 10.11.2021.
//

import CoreLocation
import Foundation

public final class WeatherService: NSObject {
    private let locationManager = CLLocationManager()
    private let API_KEY = "889146dc21bf2e7320adf2d541e5d7d9"
    private var complitionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ complitionHandler: @escaping ((Weather) -> Void)) {
        self.complitionHandler = complitionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString =
                "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {return}
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.complitionHandler?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {return}
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error) {
        print("Что то не так: \(error.localizedDescription)")
    }
}

struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWearher]
}

struct APIMain: Decodable {
    let temp: Double
}

struct APIWearher: Decodable {
    
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
    
}

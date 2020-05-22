//
//  CustomAnnotation.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/4/1.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation, Codable {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var cityName: String = ""
    var desc: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case cityName = "title"
        case desc
        case latitude
        case longitude
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try values.decode(String.self, forKey: .cityName)
        desc = try values.decode(String.self, forKey: .desc)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
    
    var title: String? {
        return cityName
    }
    
    var subtitle: String? {
        return desc
    }
    
    
    static func places() -> [CustomAnnotation]? {
        if let path = Bundle.main.path(forResource: "place", ofType: "plist") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let decoder = PropertyListDecoder()
                let models = try decoder.decode([CustomAnnotation].self, from: data)
                return models
            } catch {
                print("get place error")
            }
        }
        return nil
    }
}


class SearchPlace: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}

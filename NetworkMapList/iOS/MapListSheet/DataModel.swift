//
//  DataModel.swift
//  MapListSheet
//
//  Created by James Wegner on 8/5/24.
//

import CoreLocation
import Foundation

struct Food: Codable, Identifiable {
    let id: String
    let name: String
    let emoji: String

    private var latitude: Double?
    private var longitude: Double?

    var location: CLLocationCoordinate2D? {
        guard let latitude, let longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.latitude = try? container.decode(Double.self, forKey: .latitude)
        self.longitude = try? container.decode(Double.self, forKey: .longitude)
    }

    init(id: String? = nil, name: String, emoji: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.emoji = emoji
        self.latitude = latitude
        self.longitude = longitude
    }
}

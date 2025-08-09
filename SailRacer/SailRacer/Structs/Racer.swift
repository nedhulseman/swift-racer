//
//  Racer.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/7/25.
//

import Foundation
import MapKit

struct RaceDataRow: Codable, Identifiable {
    let id = UUID()
    let timestamp: Date
    var vmg: Double
    var sog: Double
    var elapsedtime: Double
    var latitude: Double
    var longitude: Double
    var place: Int?
}


struct Racer: Identifiable  {
    var boat_class: SailboatClass
    var course_id: UUID
    var user_id: UUID
    
    var raceDataTable: [RaceDataRow] = []
    let id = UUID()
    var racing: Bool = false
}

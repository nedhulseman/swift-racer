//
//  Course.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/27/25.
//

import MapKit
import SwiftUI
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
let colors: [Color] = [.yellow, .blue, .teal, .orange, .red]
struct Marker: Equatable, Identifiable {
    var id = UUID()
    let type: String
    let name: String

    var order: Int
    let coordinate: CLLocationCoordinate2D
    var color: Color
}
struct RaceLocation: Equatable {
    var name: String
    var title: String
    var subtitle: String
    var url: String
    var longitude: Double
    var latitude: Double
}

struct Course: Equatable, Identifiable {
    let id = UUID()
    var name: String = ""
    var race_committee_pin: String = String(format: "%04d", Int.random(in: 0...9999))
    //var race_city: String = ""
    //var race_state: String = ""
    var race_location: RaceLocation?
    var start_date: Date = Date()
    //private var code: String //perhaps to implement later
    var useStartAsFinishLine: Bool = false
    var markers: [Marker] = []
    var race_type: RaceType = default_race_type
    var boat_classes: [SailboatClass] = []
}

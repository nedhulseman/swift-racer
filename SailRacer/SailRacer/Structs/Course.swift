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

struct Marker: Equatable, Identifiable, Hashable {
    var id = UUID()
    let type: String
    let name: String
    var order: Int
    let coordinate: CLLocationCoordinate2D

    var colorName: String

    var color: Color {
        switch colorName.lowercased() {
        case "yellow": return .yellow
        case "blue": return .blue
        case "teal": return .teal
        case "orange": return .orange
        case "red": return .red
        default: return .black
        }
    }
}

let colors = ["yellow", "blue", "teal", "orange", "red", "black"]

extension Marker {
    init(type: String, name: String, order: Int, coordinate: CLLocationCoordinate2D, color: Color) {
        self.type = type
        self.name = name
        self.order = order
        self.coordinate = coordinate
        
        // Convert Color to string name
        switch color {
        case .yellow: self.colorName = "yellow"
        case .blue: self.colorName = "blue"
        case .teal: self.colorName = "teal"
        case .orange: self.colorName = "orange"
        case .red: self.colorName = "red"
        default: self.colorName = "black"
        }
    }
}

struct RaceLocation: Equatable, Hashable {
    var name: String
    var title: String
    var subtitle: String
    var url: String
    var longitude: Double
    var latitude: Double
}




class Course: ObservableObject, Identifiable {
    let id = UUID()
    @Published var start_countdown: Int
    @Published var racing: Bool
    @Published var presentCountdown: Bool
    @Published var name: String
    @Published var race_committee_pin: String
    @Published var race_location: RaceLocation?
    @Published var start_date: Date
    @Published var useStartAsFinishLine: Bool
    @Published var markers: [Marker]
    @Published var race_type: RaceType
    @Published var boat_classes: [SailboatClass]

    init(
        start_countdown: Int = 180,
        racing: Bool = false,
        presentCountdown: Bool = false,
        name: String = "",
        race_committee_pin: String = String(format: "%04d", Int.random(in: 0...9999)),
        race_location: RaceLocation? = nil,
        start_date: Date = Date(),
        useStartAsFinishLine: Bool = false,
        markers: [Marker] = [],
        race_type: RaceType = .oneDesign,
        boat_classes: [SailboatClass] = []
    ) {
        self.start_countdown = start_countdown
        self.racing = racing
        self.presentCountdown = presentCountdown
        self.name = name
        self.race_committee_pin = race_committee_pin
        self.race_location = race_location
        self.start_date = start_date
        self.useStartAsFinishLine = useStartAsFinishLine
        self.markers = markers
        self.race_type = race_type
        self.boat_classes = boat_classes
    }
    func startRace() {
        //
    }
}



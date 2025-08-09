//
//  DevStructs.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//
import SwiftUI
import CoreLocation

let courses_for_dev = [
    Course(
        start_countdown:  180,
        racing: false,
        name: "SCOW WNR",
        race_committee_pin: "1782",
        race_location: RaceLocation(
            name: "Washington Sailing Marina",
            title: "1 Marina Dr, Alexandria, VA  22314, United States",
            subtitle: "Unknown",
            url: "https://boatingindc.com/boathouses/washington-sailing-marina",
            longitude: -77.0421647,
            latitude: 38.8332269
        ),
        start_date: ISO8601DateFormatter().date(from: "2025-08-06T19:24:00Z")!,
        useStartAsFinishLine: true,
        markers: [
            Marker(
                type: "Start (Race Committee)",
                name: "Start RC",
                order: 1,
                coordinate: CLLocationCoordinate2D(latitude: 38.827314, longitude: -77.0308),
                color: .yellow
            ),
            Marker(
                type: "Start (Pin End)",
                name: "Start PE",
                order: 2,
                coordinate: CLLocationCoordinate2D(latitude: 38.827314, longitude: -77.029),
                color: .blue
            ),
            Marker(
                type: "Distance",
                name: "Windard",
                order: 3,
                coordinate: CLLocationCoordinate2D(latitude: 38.8228, longitude: -77.03),
                color: .teal
            ),
            Marker(
                type: "Distance",
                name: "Leeward",
                order: 4,
                coordinate: CLLocationCoordinate2D(latitude: 38.831, longitude: -77.03),
                color: .orange
            )
        ],
        race_type: RaceType.oneDesign,
        boat_classes: [
            SailboatClass(
                name: "Albacore",
                category: .classic
            ),
            SailboatClass(
                name: "Flying Scot",
                category: .classic
            ),
            SailboatClass(
                name: "Laser / ILCA",
                category: .dinghy
            )
        ]
    ),
]

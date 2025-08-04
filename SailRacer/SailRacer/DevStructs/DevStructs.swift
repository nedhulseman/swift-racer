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
                id: UUID(uuidString: "C7CFB8DA-EFFD-4C9E-A42D-0CC62F18DC78")!,
                type: "Start (Race Committee)",
                name: "Start RC",
                order: 1,
                coordinate: CLLocationCoordinate2D(latitude: 38.827314, longitude: -77.0308),
                color: .yellow
            ),
            Marker(
                id: UUID(uuidString: "59ABD2A4-4B48-4990-82DC-F33992D63021")!,
                type: "Start (Pin End)",
                name: "Start PE",
                order: 2,
                coordinate: CLLocationCoordinate2D(latitude: 38.827314, longitude: -77.029),
                color: .blue
            ),
            Marker(
                id: UUID(uuidString: "E314477B-4D38-4661-8568-8CBB4774B883")!,
                type: "Distance",
                name: "Windard",
                order: 3,
                coordinate: CLLocationCoordinate2D(latitude: 38.8228, longitude: -77.03),
                color: .teal
            ),
            Marker(
                id: UUID(uuidString: "02798C79-E701-43CB-A850-E5FEC4A9494A")!,
                type: "Distance",
                name: "Leeward",
                order: 4,
                coordinate: CLLocationCoordinate2D(latitude: 38.831, longitude: -77.03),
                color: .orange
            )
        ],
        race_type: .oneDesign,
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

//
//  races.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//

enum RaceType: String, CaseIterable, Identifiable {
    case oneDesign = "One-Design"
    case phrf = "PHRF"

    var id: String { rawValue }
}

let default_race_type = RaceType.oneDesign

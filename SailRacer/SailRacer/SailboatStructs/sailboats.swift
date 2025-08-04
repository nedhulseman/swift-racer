//
//  sailboats.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//

import Foundation

struct SailboatClass: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: SailboatCategory
}

enum SailboatCategory: String, CaseIterable, Identifiable {
    case dinghy = "Dinghy (1–2 Person)"
    case skiff = "Performance Dinghy / Skiff"
    case keelboat = "Keelboat / Sportboat"
    case classic = "Classic or Larger One-Design"

    var id: String { rawValue }
}

let oneDesignSailboats: [SailboatClass] = [
    // Dinghy (1–2 Person)
    .init(name: "Laser / ILCA", category: .dinghy),
    .init(name: "Sunfish", category: .dinghy),
    .init(name: "Optimist", category: .dinghy),
    .init(name: "420", category: .dinghy),
    .init(name: "470", category: .dinghy),
    .init(name: "RS Aero", category: .dinghy),
    .init(name: "Byte CII", category: .dinghy),
    .init(name: "Topper", category: .dinghy),
    .init(name: "Finn", category: .dinghy),

    // Performance Dinghy / Skiff
    .init(name: "29er", category: .skiff),
    .init(name: "49er", category: .skiff),
    .init(name: "49erFX", category: .skiff),
    .init(name: "Moth (Foiling)", category: .skiff),
    .init(name: "Waszp", category: .skiff),
    .init(name: "VX One", category: .skiff),

    // Keelboat / Sportboat
    .init(name: "J/22", category: .keelboat),
    .init(name: "J/24", category: .keelboat),
    .init(name: "J/70", category: .keelboat),
    .init(name: "Etchells", category: .keelboat),
    .init(name: "Melges 20", category: .keelboat),
    .init(name: "Melges 24", category: .keelboat),
    .init(name: "Sonar", category: .keelboat),
    .init(name: "Ideal 18", category: .keelboat),
    .init(name: "Soling", category: .keelboat),

    // Classic or Larger One-Design
    .init(name: "Dragon", category: .classic),
    .init(name: "Snipe", category: .classic),
    .init(name: "Thistle", category: .classic),
    .init(name: "Lightning", category: .classic),
    .init(name: "Flying Scot", category: .classic),
    .init(name: "Star", category: .classic),
    .init(name: "Albacore", category: .classic)
]

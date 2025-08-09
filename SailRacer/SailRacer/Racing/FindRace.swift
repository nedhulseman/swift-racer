//
//  FindRace.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//

import SwiftUI
import MapKit

enum ActiveNavigation: Identifiable {
    case racing(Course)
    case raceCommittee(Course)

    var id: UUID {
        switch self {
        case .racing(let course), .raceCommittee(let course):
            return course.id
        }
    }
}


struct FindRace: View {
    @StateObject private var locationManager = LocationManagerCustom()
    @FocusState private var startDateFocused: Bool
    @State private var date: Date = Date()
    @State private var selectedCourse: Course? = nil
    @State private var activeNav: ActiveNavigation? = nil






    var body: some View {
        VStack{
            DatePicker("Date of Race", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact) // .wheel, .graphical, or .compact
                .padding()
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            NavigationStack {
                List {
                    ForEach(courses_for_dev, id: \.id) { course in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(course.name.isEmpty ? "Unnamed Course" : course.name)
                                .font(.headline)
                            
                            if let location = course.race_location {
                                Text(location.name)
                                    .font(.subheadline)
                            }
                            
                            Text("Start Date: \(formattedDate(course.start_date))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(course.markers.count) marker\(course.markers.count == 1 ? "" : "s")")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCourse = course
                        }
                        
                    }
                }
                .navigationTitle("My Courses")
                .sheet(item: $selectedCourse) { course in
                    JoinRaceForm(course: course) { joinType in
                        if let joinType = joinType {
                            switch joinType {
                            case .raceCommittee:
                                activeNav = .raceCommittee(course)
                            case .racer:
                                activeNav = .racing(course)
                            }
                        }
                        selectedCourse = nil
                    }
                }
                .fullScreenCover(item: $activeNav) { nav in
                    switch nav {
                    case .racing(let course):
                        RacingView(course: course)
                    case .raceCommittee(let course):
                        RaceCommitteeView(course: course)
                    }
                }

            }
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    FindRace()
}

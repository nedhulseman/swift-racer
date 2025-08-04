//
//  FindRace.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//

import SwiftUI
import MapKit

struct FindRace: View {
    @StateObject private var locationManager = LocationManagerCustom()
    @FocusState private var startDateFocused: Bool
    @State private var date: Date = Date()
    @State private var selectedCourse: Course? = nil


    var body: some View {
        VStack{
            DatePicker("Date of Race", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact) // .wheel, .graphical, or .compact
                .padding()
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            NavigationView {
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
                        .contentShape(Rectangle()) // 👈 Makes entire row tappable
                        .onTapGesture {
                            selectedCourse = course // 👈 Triggers the sheet
                        }

                    }
                }
                .navigationTitle("My Courses")
                .sheet(item: $selectedCourse) { course in
                    JoinRaceForm(course: course) {
                        selectedCourse = nil
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

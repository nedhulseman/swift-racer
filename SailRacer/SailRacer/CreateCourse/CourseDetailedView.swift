//
//  CourseDetailedView.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/2/25.
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Info")) {
                    Text("Name: \(course.name.isEmpty ? "Unnamed Course" : course.name)")
                    Text("Start Date: \(formattedDate(course.start_date))")
                    Toggle("Uses Start as Finish Line", isOn: .constant(course.useStartAsFinishLine))
                        .disabled(true)
                }

                if let location = course.race_location {
                    Section(header: Text("Location")) {
                        Text("Name: \(location.name)")
                        Text("Title: \(location.title)")
                        Text("Subtitle: \(location.subtitle)")
                        Text("Coordinates: \(location.latitude), \(location.longitude)")
                        if let url = URL(string: location.url) {
                            Link("More Info", destination: url)
                        }
                    }
                }

                Section(header: Text("Markers")) {
                    if course.markers.isEmpty {
                        Text("No markers added.")
                    } else {
                        ForEach(course.markers.sorted(by: { $0.order < $1.order })) { marker in
                            VStack(alignment: .leading) {
                                Text(marker.name)
                                    .font(.headline)
                                Text("Type: \(marker.type), Order: \(marker.order)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Course Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    CourseDetailView(course: Course())
}

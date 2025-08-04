//
//  CreateCourseLanding.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/2/25.
//

import SwiftUI


struct CreateCourseLanding: View {
    @State private var courses: [Course] = courses_for_dev
    @State private var showCreateRace = false
    @State private var selectedCourse: Course? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(courses, id: \.id) { course in
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
                    .onTapGesture {
                        selectedCourse = course // 👈 Set selected course
                    }
                }
            }
            .navigationTitle("My Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateRace = true
                    } label: {
                        Label("New Race", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: Binding<Bool>(
                get: { selectedCourse != nil },
                set: { if !$0 { selectedCourse = nil } }
            )) {
                if let course = selectedCourse {
                    CourseDetailView(course: course)
                }
            }
            .sheet(isPresented: $showCreateRace) {
                CreateRace { newCourse in
                    courses.append(newCourse)
                    showCreateRace = false
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
    CreateCourseLanding()
}

//
//  JoinRaceForm.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//

import SwiftUI

struct JoinRaceForm: View {
    var course: Course
    var onJoin: () -> Void

      var body: some View {
          VStack(spacing: 20) {
              Text("Join \"\(course.name)\"?")
                  .font(.title2)
                  .multilineTextAlignment(.center)

              if let location = course.race_location {
                  Text("Location: \(location.name)")
                      .foregroundColor(.secondary)
              }

              Text("Start: \(DateFormatter.localizedString(from: course.start_date, dateStyle: .medium, timeStyle: .none))")
                  .foregroundColor(.secondary)

              Button(action: {
                  onJoin()
              }) {
                  Text("Join Race")
                      .frame(maxWidth: .infinity)
                      .padding()
                      .background(Color.accentColor)
                      .foregroundColor(.white)
                      .cornerRadius(8)
              }

              Button("Cancel") {
                  onJoin() // Dismiss without joining
              }
              .foregroundColor(.red)
          }
          .padding()
          .presentationDetents([.medium])
      }
}



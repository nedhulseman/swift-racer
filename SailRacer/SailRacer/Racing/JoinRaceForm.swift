//
//  JoinRaceForm.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/3/25.
//

import SwiftUI

struct JoinRaceForm: View {
    var course: Course
    @State private var chosen_boat_class: SailboatClass
    @State private var boat_name: String = ""
    @FocusState private var focusedIndex: Int?
    @State private var digits: [String] = Array(repeating: "", count: 4)
    
    
    var onJoin: (JoinType?) -> Void
    init(course: Course, onJoin: @escaping (JoinType?) -> Void) {
        self.course = course
        self.onJoin = onJoin
        _chosen_boat_class = State(initialValue: course.boat_classes.first!)
    }
      var body: some View {
          @State var chosen_boat_class: SailboatClass = course.boat_classes.first!
          @State var boat_name: String = ""

          
          VStack(spacing: 20) {
              Text("Join \(course.name)")
                  .font(.title2)
                  .multilineTextAlignment(.center)

              if let location = course.race_location {
                  Text("Location: \(location.name)")
                      .foregroundColor(.secondary)
              }

              Text("Start: \(DateFormatter.localizedString(from: course.start_date, dateStyle: .medium, timeStyle: .none))")
                  .foregroundColor(.secondary)
              Form{
                  TextField("Boat Name", text: $boat_name)
                  Picker("Boat Class", selection: $chosen_boat_class) {
                      ForEach(course.boat_classes) { boatClass in
                          Text(boatClass.name).tag(boatClass)
                      }
                  }
                  Section(header: Text("Race Committee PIN").font(.headline)) {
                      VStack(alignment: .leading, spacing: 8) {
                          HStack(spacing: 12) {
                              ForEach(0..<4, id: \.self) { index in
                                  TextField("", text: Binding(
                                      get: { digits[index] },
                                      set: { newValue in
                                          if newValue.count <= 1, newValue.allSatisfy(\.isNumber) {
                                              digits[index] = newValue
                                              if newValue.count == 1 {
                                                  focusedIndex = index < 3 ? index + 1 : nil
                                              }
                                          } else if newValue.isEmpty {
                                              digits[index] = ""
                                              focusedIndex = index > 0 ? index - 1 : nil
                                          }
                                      })
                                  )
                                  .keyboardType(.numberPad)
                                  .multilineTextAlignment(.center)
                                  .font(.title)
                                  .frame(width: 50, height: 50)
                                  .background(Color(.secondarySystemBackground))
                                  .cornerRadius(8)
                                  .focused($focusedIndex, equals: index)
                              }
                          }

                          Text("If you're joining as Race Committee instead of a racer, enter the 4-digit RC PIN here. Leave blank if you're racing.")
                              .font(.footnote)
                              .foregroundColor(.secondary)
                              .padding(.top, 4)
                      }
                      .onAppear {
                          focusedIndex = 0
                      }
                      .onChange(of: digits) { newDigits in
                          let pin = newDigits.joined()
                          if pin.count == 4 {
                              print("Entered RC PIN: \(pin)")
                              // Handle PIN logic here
                          }
                      }
                  }


              }
              Button("Cancel") {
                  onJoin(nil)
              }

              Button("Join Race") {
                  let pin = digits.joined()
                  if pin.count == 4 {
                      // Match against your actual RC PIN logic here
                      // For now, assume "1234" is the valid RC PIN
                      if pin == course.race_committee_pin {
                          print("Correct RC PIN.")
                          print(course.race_committee_pin)
                          print(pin)

                          onJoin(.raceCommittee)
                      } else {
                          // Invalid RC PIN? Maybe show alert
                          // For now, fallback to racer
                          print("Incorrect RC PIN.")
                      }
                  } else {
                      onJoin(.racer)
                  }
              }
          }
          .padding()
          .presentationDetents([.medium])
      }
}



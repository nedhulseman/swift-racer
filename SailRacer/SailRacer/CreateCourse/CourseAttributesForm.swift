//
//  CourseAttributes.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/27/25.
//

import SwiftUI

struct CourseAttributesForm: View {
    @Binding var course: Course
    
    @State private var selectedState = "California"
    let states = ["Alabama", "Alaska", "Arizona", "California", "Colorado", "Maryland", "New York", "Texas", "Virginia"]
    @State private var startIsFinish: Bool = false
    @FocusState private var useStartAsFinishLineFocused: Bool
    @FocusState private var nameFocused: Bool
    @FocusState private var startIsFinishFocused: Bool
    @FocusState private var startDateFocused: Bool
    enum Status: String {
        case draft
        case final
    }
    
    var body: some View {
        Form {
            HStack{
                TextField("Name of Race", text: $course.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($nameFocused)
                
            }.padding(.horizontal)
            Picker("Select a State", selection: $selectedState) {
                ForEach(states, id: \.self) { state in
                    Text(state)
                }
            }
            .pickerStyle(.menu) // dropdown-style
            .padding()
            TextField("City", text: $course.race_city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($nameFocused)
            DatePicker("Select a date", selection: $course.start_date, displayedComponents: .date)
                .datePickerStyle(.compact) // .wheel, .graphical, or .compact
                .padding()
            Toggle("Use start line as finish line?", isOn: $course.useStartAsFinishLine)
                .focused($startIsFinishFocused)
                .padding()
            HStack {
                Button("Save as Draft") {
                    saveRace(status:Status.draft)
                }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .padding()
                Button("Publish Race") {
                    saveRace(status:Status.final)
                }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .padding()
            }

        }
    }
    func saveRace(status: Status) {
        print("Saving as \(status)")
        print(course)
    }
}


#Preview {
    CourseAttributesForm(course: .constant(Course()))
}

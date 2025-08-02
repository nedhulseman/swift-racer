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
            Section(header: Text("Name of Race")) {
                
                HStack{
                    TextField("Name of Race", text: $course.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($nameFocused)
                    
                }.padding(.horizontal)
            }
            Section(header: Text("Date of Start")) {
                DatePicker("Select a date", selection: $course.start_date, displayedComponents: .date)
                    .datePickerStyle(.compact) // .wheel, .graphical, or .compact
                    .padding()
            }
            Section(header: Text("Other Race Details")) {
                Toggle("Use start line as finish line?", isOn: $course.useStartAsFinishLine)
                    .focused($startIsFinishFocused)
                    .padding()
            }
        }
    }
}


#Preview {
    CourseAttributesForm(course: .constant(Course()))
}

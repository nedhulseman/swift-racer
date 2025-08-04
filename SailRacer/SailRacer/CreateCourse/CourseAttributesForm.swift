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
    
    @FocusState private var isFocused: Bool
    let length: Int = 4
    
    @State private var selectedRaceType: RaceType = default_race_type
    @State private var selectedClasses: Set<SailboatClass> = []
    var groupedSailboats: [SailboatCategory: [SailboatClass]] {
        Dictionary(grouping: oneDesignSailboats, by: \.category)
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
            Section(header: Text("Race Committee PIN")) {
                ZStack {
                    // Hidden but layout-visible TextField
                    TextField("", text: $course.race_committee_pin)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                        .onChange(of: course.race_committee_pin) { newValue in
                            course.race_committee_pin = String(newValue.prefix(length).filter { $0.isNumber })
                        }
                        .textContentType(.oneTimeCode)
                        .accentColor(.clear)
                        .foregroundColor(.clear)
                        .frame(height: 1)
                        .opacity(0.01)

                    // Digit boxes
                    HStack(spacing: 12) {
                        let pinArray = Array(course.race_committee_pin)
                        ForEach(0..<length, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    .frame(width: 50, height: 60)

                                if index < pinArray.count {
                                    Text(String(pinArray[index]))
                                        .font(.title)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isFocused = true
                    }
                    .frame(alignment: .center)
                }
            }
            Section(header: Text("Fleet")){
                Picker("Race Type", selection: $course.race_type) {
                    ForEach(RaceType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Toggle(isOn: Binding<Bool>(
                                    get: { selectedClasses.isEmpty },
                                    set: { isOn in
                                        if isOn {
                                            selectedClasses.removeAll() // "Any"
                                        }
                                    }
                                )) {
                                    Text("Any Class")
                                        .fontWeight(.semibold)
                                }

                                ForEach(SailboatCategory.allCases) { category in
                                    if let boats = groupedSailboats[category] {
                                        Section(header: Text(category.rawValue)) {
                                            ForEach(boats.sorted(by: { $0.name < $1.name })) { boat in
                                                Toggle(isOn: Binding<Bool>(
                                                    get: { selectedClasses.contains(boat) },
                                                    set: { isOn in
                                                        if isOn {
                                                            selectedClasses.insert(boat)
                                                        } else {
                                                            selectedClasses.remove(boat)
                                                        }
                                                    }
                                                )) {
                                                    Text(boat.name)
                                                }
                                            }
                                        }
                                    }
                                }
                            
            }
        }
        .onAppear {
            selectedClasses = Set(course.boat_classes)
        }
        .onChange(of: selectedClasses) { newValue in
            course.boat_classes = Array(newValue)
        }
    }
}


#Preview {
    CourseAttributesForm(course: .constant(Course()))
}

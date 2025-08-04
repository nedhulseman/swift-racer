import SwiftUI
import MapKit

struct CreateRace: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Course) -> Void
    @State private var course_ = Course()
    @State var selectTab = 0
    @State private var step = 1

    var body: some View {
        /*VStack {
            TabView(selection: $selectTab){

                CourseAttributesForm(course: $course_)
                    .tag(0)
                    .tabItem {
                        Text("Create a Race")
                    }
                CourseGeoLocateForm(course: $course_)
                    .tag(1)
                    .tabItem {
                        Text("Locate Race")
                    }
                CourseMarkersForm(course: $course_)
                    .tag(2)
                    .tabItem {
                        Text("Set Markers")
                    }
            }
            .tabViewStyle(.automatic)
        }*/
        VStack {
            // Optional progress indicator
            Text("Step \(step) of 3")
                .font(.headline)
                .padding(.top)

            Spacer()

            // Switch between steps
            switch step {
            case 1:
                CourseAttributesForm(course: $course_)
            case 2:
                CourseGeoLocateForm(course: $course_)
            case 3:
                CourseMarkersForm(course: $course_)
            default:
                EmptyView()
            }
            Spacer()

            // Navigation buttons
            HStack {
                if step > 1 {
                    Button("Back") {
                        withAnimation { step -= 1 }
                    }
                }

                Spacer()

                Button(step == 3 ? "Finish" : "Next") {
                    if step < 3 {
                        withAnimation { step += 1 }
                    } else {
                        submitCourse(course_)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
    func submitCourse(_ course: Course) {
        print(course)
        onSave(course)
        dismiss()
    }
}



import SwiftUI
import MapKit

struct CreateRace: View {
    @State private var course_ = Course()
    @State var selectTab = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectTab){

                CourseLanding(course: $course_)
                    .tag(0)
                    .tabItem {
                        Text("Race Overview Form")
                    }
                CourseAttributesForm(course: $course_)
                    .tag(1)
                    .tabItem {
                        Text("Create a Race")
                    }
                CourseMarkersForm(course: $course_)
                    .tag(2)
                    .tabItem {
                        Text("Set Markers")
                    }
            }
            .tabViewStyle(.automatic)
        }
    }
}

#Preview {
    CreateRace()
}

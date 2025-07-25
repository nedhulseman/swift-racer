import SwiftUI
import MapKit

struct CreateRace: View {
    @StateObject private var locationManager = LocationManager()
    struct Marker: Identifiable {
        let id = UUID()
        let type: String
        let name: String
        let order: Int
        let coordinate: CLLocationCoordinate2D
    }
    @State private var course = [
        Marker(type: "start", name:"Placeholder", order: 1, coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
    ]
    @State private var selectedOption = "Start (Race Committee)"
    let options = ["Start (Race Committee)", "Start (Pin End)", "Distance"]
    @Environment(\.editMode) private var editMode
    @State private var longitude: String = ""
    @State private var latitude: String = ""
    @State private var markerName: String = ""

    @FocusState private var longitudeFocused: Bool
    @FocusState private var latitudeFocused: Bool
    @FocusState private var markerNameFocused: Bool

    @State private var showCoordinatesFields: Bool = false


    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                // Map as header
                if showCoordinatesFields {
                    VStack {
                        HStack{
                            TextField("Latitude", text: $latitude)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($longitudeFocused)
                            TextField("Longitude", text: $longitude)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($latitudeFocused)
                        }.padding()
                    }
                        HStack {
                            TextField("Marker Name", text: $markerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($markerNameFocused)

                        }.padding()
                    Picker("Choose an option", selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.inline) // or .segmented
                    
                    Button("Add Marker") {
                        addMarker()
                    }
                }
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: course) { marker in
                    MapAnnotation(coordinate: marker.coordinate) {
                        VStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(marker.type)
                                .font(.caption)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                    }
                }
                .frame(height: 250)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets())
                
                List {
                    ForEach(Array(course.enumerated()), id: \.element.id) { index, item in
                        Text("\tMarker Type: \(item.type)")
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Add Markers")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Use Current Location") {
                            print("Option 1 selected")
                        }
                        Button("Use Coordinates") {
                            showCoordinatesFields.toggle()
                        }
                    } label: {
                        Label("Add a marker", systemImage: "plus")
                    }
                    EditButton()
                }
            }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        course.move(fromOffsets: source, toOffset: destination)
    }

    func addMarker() {
        if let lat = Double(latitude),
           let lon = Double(longitude) {
            
            let newMarker = Marker(type: "race", name:markerName, order: 5, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            course.append(newMarker)
            showCoordinatesFields.toggle()
        } else {
            print("Invalid input: Please enter valid numbers.")
        }
    }

}

#Preview {
    CreateRace()
}

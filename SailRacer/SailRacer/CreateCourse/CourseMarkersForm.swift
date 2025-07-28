//
//  CourseMarkersFormswift.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/27/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct CourseMarkersForm: View {
    @StateObject private var locationManager = LocationManagerCustom()
    @Binding var course: Course
    
    /*
     fake race course
     38.824398, -77.034441 - Start RC
     38.824331, -77.032295 - Start Pin
     38.818981, -77.033368 - Windward
     38.829911, -77.035158 - Leward
     
     */
    
    
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
                    Form {
                        VStack {
                            Button("Get Current Location") {
                                getCurrentLocation()
                            }
                            HStack{
                                TextField("Latitude", text: $latitude)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($longitudeFocused)
                                TextField("Longitude", text: $longitude)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($latitudeFocused)
                            }.padding(.horizontal)
                        }
                        HStack {
                            TextField("Marker Name", text: $markerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($markerNameFocused)
                            
                        }
                        .padding()
                        Picker("Choose Marker Type", selection: $selectedOption) {
                            ForEach(options, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.menu) // or .segmented

                        Button("Add Marker") {
                            addMarker()
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: course.markers) { marker in
                    MapAnnotation(coordinate: marker.coordinate) {
                        VStack {
                            Image(systemName: "mappin")
                                .foregroundColor(marker.color)
                                .font(.title)
                            Text(marker.name)
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
                    ForEach(Array(course.markers.enumerated()), id: \.element.id) { index, item in
                        HStack {
                            Image(systemName: "mappin")
                                .foregroundColor(item.color)
                            Text("\tMarker Type: \(item.type)")
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCoordinatesFields.toggle()
                    }) {
                        Label("Add a marker", systemImage: "plus")
                    }
                    EditButton()
                }
            }
        }
    }
    func getCurrentLocation()  {
        if let coordinate = locationManager.location {
                latitude = String(coordinate.latitude)
                longitude = String(coordinate.longitude)
        } else {
            print("Locating...")
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        course.markers.move(fromOffsets: source, toOffset: destination)
        updateMarkerAttributes()
    }
    func delete(at offsets: IndexSet) {
        course.markers.remove(atOffsets: offsets)
    }

    func addMarker() {
        if let lat = Double(latitude),
           let lon = Double(longitude) {
            
            let newMarker = Marker(type: selectedOption, name:markerName, order: 5, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), color:colors[course.markers.count])
            

            course.markers.append(newMarker)
            let coordinates = course.markers.map { $0.coordinate }
            let newRegion = regionForCoordinates(coordinates)
            locationManager.region = newRegion

            showCoordinatesFields.toggle()
        } else {
            print("Invalid input: Please enter valid numbers.")
        }
    }
    func updateMarkerAttributes() {
        for (index, var Marker) in course.markers.enumerated() {
            // Modify the properties of the structItem (which is a copy)
            Marker.order = index + 1
            Marker.color = colors[index]

            //Marker.type = Marker.type
            //Marker.name = Marker.name
            //Marker.coordinate = Marker.coordinate
            //Marker.id = Marker.id
            
            // Assign the modified copy back to the original array at its index
            course.markers[index] = Marker
        }
    }
    func regionForCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            // Default fallback region
            return locationManager.region
        }

        var minLat = coordinates.first!.latitude
        var maxLat = coordinates.first!.latitude
        var minLon = coordinates.first!.longitude
        var maxLon = coordinates.first!.longitude

        for coord in coordinates {
            minLat = min(minLat, coord.latitude)
            maxLat = max(maxLat, coord.latitude)
            minLon = min(minLon, coord.longitude)
            maxLon = max(maxLon, coord.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,  // Add padding
            longitudeDelta: (maxLon - minLon) * 1.5
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}

#Preview {
    CourseMarkersForm(course: .constant(Course()))
}

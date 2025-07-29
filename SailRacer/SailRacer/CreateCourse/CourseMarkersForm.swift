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
    
    @State private var showAddMarkerSheet = false
    
    @Environment(\.editMode) private var editMode

    var body: some View {
        NavigationView {
            VStack {
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
                .shadow(radius: 4)
                .padding()

                List {
                    if course.markers.isEmpty {
                        Text("No markers yet. Tap '+' to add one.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Section(header: Text("Course Markers")) {
                            ForEach(Array(course.markers.enumerated()), id: \.element.id) { index, item in
                                HStack {
                                    Image(systemName: "mappin")
                                        .foregroundColor(item.color)
                                    VStack(alignment: .leading) {
                                        Text(item.name.isEmpty ? "Unnamed Marker" : item.name)
                                            .fontWeight(.semibold)
                                        Text("Type: \(item.type)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .onDelete(perform: delete)
                            .onMove(perform: move)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddMarkerSheet = true
                    }) {
                        Label("Add Marker", systemImage: "plus")
                    }
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddMarkerSheet) {
                AddMarkerFormView(locationManager: locationManager) { newMarker in
                    course.markers.append(newMarker)
                    updateMarkerAttributes()
                    locationManager.region = regionForCoordinates(course.markers.map(\.coordinate))
                    showAddMarkerSheet = false
                }
            }

        }
    }

    func move(from source: IndexSet, to destination: Int) {
        course.markers.move(fromOffsets: source, toOffset: destination)
        updateMarkerAttributes()
    }

    func delete(at offsets: IndexSet) {
        course.markers.remove(atOffsets: offsets)
        updateMarkerAttributes()
    }

    func updateMarkerAttributes() {
        for (index, var marker) in course.markers.enumerated() {
            marker.order = index + 1
            marker.color = colors[index % colors.count]
            course.markers[index] = marker
        }
    }

    func regionForCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
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
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.005),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.005)
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}

struct AddMarkerFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var locationManager: LocationManagerCustom

    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var markerName: String = ""
    @State private var selectedOption = "Start (Race Committee)"
    let options = ["Start (Race Committee)", "Start (Pin End)", "Distance"]

    let onAdd: (Marker) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Marker Details")) {
                    TextField("Marker Name", text: $markerName)
                    
                    Picker("Marker Type", selection: $selectedOption) {
                        ForEach(options, id: \.self) { Text($0) }
                    }
                }
                Section(header: Text("Location Details")) {
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)

                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                    Button("Fill Using Current Location") {
                        getCurrentLocation()
                    }
                }

                Section {
                    Button("Add Marker") {
                        addMarker()
                    }
                    .disabled(!canAddMarker)
                }
            }
            .navigationTitle("New Marker")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }

    var canAddMarker: Bool {
        Double(latitude) != nil && Double(longitude) != nil
    }

    func addMarker() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else { return }

        let marker = Marker(
            type: selectedOption,
            name: markerName,
            order: 0, // will be updated outside
            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            color: .blue // temporary; updated by parent
        )

        onAdd(marker)
    }
    func getCurrentLocation() {
        if let coordinate = locationManager.location {
            latitude = String(coordinate.latitude)
            longitude = String(coordinate.longitude)
        } else {
            print("Locating...")
        }
    }
}


#Preview {
    CourseMarkersForm(course: .constant(Course()))
}

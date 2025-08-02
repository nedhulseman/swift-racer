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
    @State private var editingMarker: Marker? = nil

    
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
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    // Delete action
                                    Button(role: .destructive) {
                                        delete(at: IndexSet(integer: index))
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    // Edit action
                                    Button {
                                        edit(at: IndexSet(integer: index))
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
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
                AddMarkerFormView(
                    locationManager: locationManager,
                    existingMarker: editingMarker
                ) { updatedMarker in
                    if let original = editingMarker,
                       let index = course.markers.firstIndex(where: { $0.id == original.id }) {
                        // Editing
                        course.markers[index] = updatedMarker
                    } else {
                        // Adding new
                        course.markers.append(updatedMarker)
                    }
                    updateMarkerAttributes()
                    locationManager.region = regionForCoordinates(course.markers.map(\.coordinate))
                    editingMarker = nil
                    showAddMarkerSheet = false
                }
            }

        }
    }

    func move(from source: IndexSet, to destination: Int) {
        course.markers.move(fromOffsets: source, toOffset: destination)
        updateMarkerAttributes()
    }
    func edit(at offsets: IndexSet) {
        if let index = offsets.first {
            editingMarker = course.markers[index]
            showAddMarkerSheet = true
        }
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

    var existingMarker: Marker?
    let onSave: (Marker) -> Void

    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var markerName: String = ""
    @State private var selectedOption: String = "Start (Race Committee)"

    let options = ["Start (Race Committee)", "Start (Pin End)", "Distance"]

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
                    Button(existingMarker == nil ? "Add Marker" : "Save Changes") {
                        saveMarker()
                    }
                    .disabled(!canSaveMarker)
                }
            }
            .navigationTitle(existingMarker == nil ? "New Marker" : "Edit Marker")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .onAppear {
                if let marker = existingMarker {
                    markerName = marker.name
                    selectedOption = marker.type
                    latitude = String(marker.coordinate.latitude)
                    longitude = String(marker.coordinate.longitude)
                }
            }
        }
    }

    var canSaveMarker: Bool {
        Double(latitude) != nil && Double(longitude) != nil
    }

    func saveMarker() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else { return }

        let marker = Marker(
            id: existingMarker?.id ?? UUID(),
            type: selectedOption,
            name: markerName,
            order: 0, // will be updated outside
            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            color: existingMarker?.color ?? .blue
        )

        onSave(marker)
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

//
//  CourseLanding.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/27/25.
//

import SwiftUI
import MapKit



struct CourseGeoLocateForm: View {
    @Binding var course: Course
    @StateObject private var locationManager = LocationManagerCustom()
    @State private var searchQuery = ""
    @StateObject private var searchCompleter = SearchCompleter()
    @State private var selectedLocation: MKMapItem? = nil

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search for a location", text: $searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchQuery) { newValue in
                    searchCompleter.queryFragment = newValue
                }

            // Suggestion List
            List(searchCompleter.results, id: \.self) { suggestion in
                Button(action: {
                    searchCompleter.selectSuggestion(suggestion) { item in
                        selectedLocation = item
                        setCourseLocation()
                        withAnimation {
                            searchQuery = ""
                            searchCompleter.results = []
                        }
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(suggestion.title)
                            .font(.headline)
                        Text(suggestion.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(PlainListStyle())
            if let location = course.race_location {
                VStack(alignment: .leading, spacing: 6) {
                    Text(location.name)
                        .font(.title3)
                        .bold()

                    Text(location.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(location.subtitle)
                        .font(.footnote)
                        .foregroundColor(.gray)

                    HStack(spacing: 10) {
                        Label("\(location.latitude, specifier: "%.4f")", systemImage: "arrow.up.and.down")
                        Label("\(location.longitude, specifier: "%.4f")", systemImage: "arrow.left.and.right")
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 8)
            }

            // Map preview
            if let coordinate = selectedLocation?.placemark.coordinate {
                Map(coordinateRegion: .constant(
                    MKCoordinateRegion(center: coordinate,
                                       latitudinalMeters: 1000,
                                       longitudinalMeters: 1000)),
                    annotationItems: [selectedLocation!]) { item in
                    MapMarker(coordinate: item.placemark.coordinate, tint: .blue)
                }
                .frame(height: 300)
            }
        }
        .padding()
    }
    func setCourseLocation(){
        course.race_location = RaceLocation(
            name: selectedLocation?.name ??  "Unknown",
            title: selectedLocation?.placemark.title ??  "Unknown",
            subtitle: selectedLocation?.placemark.subtitle ??  "Unknown",
            url: selectedLocation?.url?.absoluteString ?? "",
            longitude: selectedLocation?.placemark.coordinate.longitude ?? 0,
            latitude: selectedLocation?.placemark.coordinate.latitude ?? 0
        )
        print(selectedLocation)
    }
    class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
        @Published var results: [MKLocalSearchCompletion] = []
        var completer: MKLocalSearchCompleter

        override init() {
            completer = MKLocalSearchCompleter()
            super.init()
            completer.delegate = self
        }

        var queryFragment: String = "" {
            didSet {
                completer.queryFragment = queryFragment
            }
        }

        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            results = completer.results
        }

        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            print("Search completer error: \(error.localizedDescription)")
        }

        func selectSuggestion(_ suggestion: MKLocalSearchCompletion, completion: @escaping (MKMapItem?) -> Void) {
            let searchRequest = MKLocalSearch.Request(completion: suggestion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                if let item = response?.mapItems.first {
                    DispatchQueue.main.async {
                        completion(item)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }

}

#Preview {
    CourseGeoLocateForm(course: .constant(Course()))
}

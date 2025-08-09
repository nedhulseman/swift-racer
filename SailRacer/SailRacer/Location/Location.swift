import Foundation
import CoreLocation
import MapKit

extension MKMapItem: Identifiable {
    public var id: String {
        // Use a unique identifier; you could use name + coordinates as a fallback
        return placemark.name ?? UUID().uuidString
    }
}

class LocationManagerCustom: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to SF or any fallback
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            DispatchQueue.main.async {
                self.location = latest.coordinate
                self.region = MKCoordinateRegion(
                    center: latest.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

func regionForCoordinates(_ coordinates: [CLLocationCoordinate2D], locationManager: LocationManagerCustom) -> MKCoordinateRegion {
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

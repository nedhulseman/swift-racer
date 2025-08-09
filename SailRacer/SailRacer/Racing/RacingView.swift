//
//  RacingView.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/4/25.
//

import SwiftUI
import MapKit

func seconds_to_timer(totalSeconds: Int) -> String {
    let totalMinutes = totalSeconds / 60
    let totalHours =  totalMinutes / 60
    let remainingMinutes = totalMinutes % 60
    let remainingSeconds = totalSeconds % 60
    if totalMinutes >= 60 {
        return String(format: "%01d:%02d:%02d", totalHours, remainingMinutes, remainingSeconds)
    } else {
        return String(format: "%02d:%02d", remainingMinutes, remainingSeconds)
    }
}
func ordinalString(from number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
}
struct RacingView: View {
    var course: Course

    @StateObject private var locationManager = LocationManagerCustom()
    var vmg = 5.10
    var sog = 6.13
    var elapsed_time = -180
    var place = 4
    
    var body: some View {
        VStack{

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
            .ignoresSafeArea(edges: .top)
            .frame(height: .infinity)
            HStack{
                VStack{
                    Text("\(seconds_to_timer(totalSeconds: elapsed_time))")
                        .font(.title)
                        .bold()
                    Text("Race Timer")
                }.frame(maxWidth: .infinity)

                VStack{
                    Text(ordinalString(from: place))
                        .font(.title)
                        .bold()
                    Text("Place")
                }.frame(maxWidth: .infinity)
                VStack{
                    Text(String(format: "%.2f kts", sog))
                        .font(.title)
                        .bold()
                    Text("Race Timer")
                }.frame(maxWidth: .infinity)
                VStack{
                    Text(String(format: "%.2f kts", vmg))
                        .font(.title)
                        .bold()
                    Text("VMG")
                }.frame(maxWidth: .infinity)

            }
        }
    }
}


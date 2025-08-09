import SwiftUI
import MapKit
import AudioToolbox

struct RaceCommitteeView: View {
    @ObservedObject var course: Course
    @StateObject private var locationManager = LocationManagerCustom()

    var body: some View {
        ZStack {
            // Full-screen Map with annotations
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: course.markers) { marker in
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
            .ignoresSafeArea()

            // Overlayed Buttons at Bottom Center
            VStack {
                Spacer()

                HStack(spacing: 40) {
                    // Play Button
                    Button {
                        withAnimation {
                            course.presentCountdown = true
                        }
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(36)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Circle())
                    }

                    // Stop Button with Long Press
                    Button {
                        //course.presentCountdown = true
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(36)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                        // runTracker.stopRun()
                    })
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $course.presentCountdown, content: {
            CountdownView(course: course)
                .environmentObject(course)
        })
    }
}

//
//  ContentView.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectTab = 0
    var body: some View {
        VStack {
          
            TabView(selection: $selectTab){
                Home()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                FindRace()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "figure.sailing.circle")
                        Text("Join Race")
                    }
                CreateCourseLanding()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Race")
                    }
                MyRaces()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "chart.bar.yaxis")
                        Text("My Races")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  CountdownView.swift
//  SailRacer
//
//  Created by Ned hulseman on 8/8/25.
//
import SwiftUI

struct CountdownView: View {
    var course: Course
    @State var timer: Timer?
    @State var countdown = 3
    var body: some View {
        Text("\(countdown)")
            .font(.system(size:256))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .onAppear(perform: {
                setupCountdown()
            })

            
    }
    func setupCountdown(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
                if countdown <= 1{
                    timer?.invalidate()
                    timer = nil
                    course.presentCountdown = false
                    //course.startRace()
                } else{
                    countdown -= 1
                }
        }
    }
}


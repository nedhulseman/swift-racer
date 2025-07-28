//
//  CourseLanding.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/27/25.
//

import SwiftUI

struct CourseLanding: View {
    @Binding var course: Course

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CourseLanding(course: .constant(Course()))
}

//
//  Home.swift
//  SailRacer
//
//  Created by Ned hulseman on 7/20/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        Image("homepage_image")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .ignoresSafeArea(.all, edges: .top) // Not .bottom
    }
}

#Preview {
    Home()
}

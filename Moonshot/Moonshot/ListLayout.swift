//
//  ListLayout.swift
//  Moonshot
//
//  Created by Mac on 19/07/2024.
//

import SwiftUI

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View {
        List(missions) { mission in
            NavigationLink(value: mission) {
                HStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(mission.formattedLaunchDate)
                            .font(.caption)
                        //MARK: Day 76. Project 15 challenge
                            .accessibilityLabel(mission.accessibleLaunchDate)
                    }
                }
            }
            .listRowBackground(Color.darkBackground)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ListLayout(astronauts: Bundle.main.decode("astronauts.json"),
               missions: Bundle.main.decode("missions.json"))
    .preferredColorScheme(.dark)
    .background(.darkBackground)
}

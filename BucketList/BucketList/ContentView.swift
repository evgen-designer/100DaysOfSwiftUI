//
//  ContentView.swift
//  BucketList
//
//  Created by Eugene Evgen on 21/10/2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
                           span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                          )
    )
    
    @State private var viewModel = ViewModel()
    @State private var selectedMapStyle = 0
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture {
                                    viewModel.selectedPlace = location
                                }
                                .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location })
                        }
                    }
                }
                .mapStyle(selectedMapStyle == 0 ? .standard : .hybrid)
                .overlay(alignment: .topTrailing) {
                    Picker("Map style", selection: $selectedMapStyle) {
                        Text("Standard").tag(0)
                        Text("Satellite").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .frame(width: 200)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.top, 50)
                    .padding(.trailing)
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.update(location: $0)
                    }
                }
            }
        } else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert(isPresented: $viewModel.showingAuthenticationError) {
                    Alert(title: Text("Error occured"), message: Text(self.viewModel.authenticationErrorMessage), dismissButton: .default(Text("OK")))
                }
        }
    }
}

#Preview {
    ContentView()
}

//
//  MapView.swift
//  RChat
//
//  Created by Andrew Morgan on 10/12/2020.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var location: CLLocationCoordinate2D
    let annotationItems: [MyAnnotationItem]
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: annotationItems) { item in
            MapPin(coordinate: item.coordinate)
        }
        .animation(.easeIn)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            BackButton(label: "Dismiss")
        })
        .onAppear(perform: setupLocation)
    }
    
    func setupLocation() {
        region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let position = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        AppearancePreviews(
            Group {
                NavigationView {
                    MapView(location: position, annotationItems: [])
                }
                NavigationView {
                    MapView(location: position, annotationItems: [MyAnnotationItem(coordinate: position)])
                }
            }
        )
    }
}

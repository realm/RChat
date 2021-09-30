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
    
    let location: CLLocationCoordinate2D
    let annotationItems: [MyAnnotationItem]
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: MapDefaults.latitude, longitude: MapDefaults.longitude),
        span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoomedOut, longitudeDelta: MapDefaults.zoomedOut))
    
    private enum MapDefaults {
        static let latitude = 51.507222
        static let longitude = -0.1275
        static let zoomedOut = 2.0
        static let zoomedIn = 0.01
    }
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: annotationItems) { item in
            MapPin(coordinate: item.coordinate)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            BackButton(label: "Dismiss")
        })
        .onAppear(perform: setupLocation)
    }
    
    func setupLocation() {
        region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoomedIn, longitudeDelta: MapDefaults.zoomedIn))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let position = CLLocationCoordinate2D(latitude: 51.007222, longitude: -0.11)
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

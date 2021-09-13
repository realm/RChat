//
//  MapThumbnailWithExpand.swift
//  RChat
//
//  Created by Andrew Morgan on 10/12/2020.
//

import MapKit
import SwiftUI

struct MapThumbnailWithExpand: View {
    let location: [Double]
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
    @State private var annotationItems = [MyAnnotationItem]()
    @State private var position = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
    @State private var showingFullMap = false
    
    private enum Dimensions {
        static let frameSize: CGFloat = 100
        static let imageSize: CGFloat = 70
        static let buttonSize: CGFloat = 30
        static let radius: CGFloat = 8
        static let buttonPadding: CGFloat = 4
    }
    
    var body: some View {
        VStack {
            Button(action: { showingFullMap.toggle() }) {
                Map(coordinateRegion: $region, annotationItems: annotationItems) { item in
                    MapPin(coordinate: item.coordinate)
                }
                .frame(width: Dimensions.imageSize, height: Dimensions.imageSize, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
            }
            NavigationLink(destination: MapView(location: position, annotationItems: annotationItems), isActive: $showingFullMap) {
                EmptyView()
            }
        }
        .onAppear(perform: setupLocation)
    }
    
    func setupLocation() {
        position = CLLocationCoordinate2D(latitude: location[1], longitude: location[0])
        region = MKCoordinateRegion(
            center: position,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        annotationItems.append(MyAnnotationItem(coordinate: position))
    }
}

struct MapThumbnailWithExpand_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            MapThumbnailWithExpand(location: [-0.10689139236939127, 51.506520923981554])
        )
        .previewLayout(.sizeThatFits)
    }
}

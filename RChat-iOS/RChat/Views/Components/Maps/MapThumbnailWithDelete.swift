//
//  MapThumbnailWithDelete.swift
//  RChat
//
//  Created by Andrew Morgan on 09/12/2020.
//

import MapKit
import SwiftUI

struct MapThumbnailWithDelete: View {
    let location: [Double]
    var action: (() -> Void)?
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
    @State private var annotationItems = [MyAnnotationItem]()
    
    private enum Dimensions {
        static let frameSize: CGFloat = 100
        static let imageSize: CGFloat = 70
        static let buttonSize: CGFloat = 30
        static let radius: CGFloat = 8
        static let buttonPadding: CGFloat = 4
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: annotationItems) { item in
                MapPin(coordinate: item.coordinate)
            }
            .frame(width: Dimensions.imageSize, height: Dimensions.imageSize, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
            if let action = action {
                VStack {
                    HStack {
                        Spacer()
                        DeleteButton(action: action, padding: Dimensions.buttonPadding)
                            .frame(width: Dimensions.buttonSize, height: Dimensions.buttonSize, alignment: .center)
                    }
                    Spacer()
                }
                .onAppear(perform: setupLocation)
                .frame(width: Dimensions.frameSize, height: Dimensions.frameSize)
            }
        }
    }
    
    func setupLocation() {
        let position = CLLocationCoordinate2D(latitude: location[1], longitude: location[0])
        region = MKCoordinateRegion(
            center: position,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        annotationItems.append(MyAnnotationItem(coordinate: position))
    }
}

struct MapThumbnailWithDelete_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                MapThumbnailWithDelete(location: [-0.10689139236939127, 51.506520923981554], action: {})
                MapThumbnailWithDelete(location: [-0.10689139236939127, 51.506520923981554])
            }
        )
        .previewLayout(.sizeThatFits)
    }
}

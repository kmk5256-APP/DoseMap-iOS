import Foundation
import SwiftUI
import Combine

@MainActor
class MapViewModel: ObservableObject {
    @Published var regions: [MapRegion] = RegionType.allCases.map { MapRegion(type: $0) }
    @Published var scale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    
    func region(for type: RegionType) -> MapRegion {
        regions.first { $0.type == type }!
    }
}

import Foundation
import SwiftUI

enum RegionType: String, CaseIterable, Identifiable, Codable {
    case oral = "Oral Lands"
    case ivFlow = "IV River"
    case drip = "Drip Falls"
    case weight = "Weight Peak"
    case pediatric = "Pediatric Valley"
    case infusion = "Infusion Highlands"
    case conversion = "Conversion Crossroads"
    case advanced = "Advanced Outposts"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .oral: return "pills.fill"
        case .ivFlow: return "drop.fill"
        case .drip: return "drop.triangle.fill"
        case .weight: return "scalemass.fill"
        case .pediatric: return "figure.and.child.holdinghands"
        case .infusion: return "waveform.path.ecg"
        case .conversion: return "arrow.left.arrow.right"
        case .advanced: return "function"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .oral: return Color(red: 0.4, green: 0.8, blue: 0.7)
        case .ivFlow: return Color(red: 0.3, green: 0.6, blue: 0.95)
        case .drip: return Color(red: 0.5, green: 0.7, blue: 1.0)
        case .weight: return Color(red: 0.95, green: 0.7, blue: 0.3)
        case .pediatric: return Color(red: 0.95, green: 0.5, blue: 0.7)
        case .infusion: return Color(red: 0.7, green: 0.4, blue: 0.95)
        case .conversion: return Color(red: 0.6, green: 0.85, blue: 0.5)
        case .advanced: return Color(red: 0.9, green: 0.4, blue: 0.4)
        }
    }
    
    var description: String {
        switch self {
        case .oral:
            return "Master tablets, capsules, and oral liquid dosages using Desired ÷ Have × Quantity."
        case .ivFlow:
            return "Calculate mL/hr infusion rates. The most common IV calculation on NCLEX."
        case .drip:
            return "Gravity drip rates in gtt/min. Remember to convert time to minutes!"
        case .weight:
            return "mg/kg dosing and weight conversions. Critical for safety."
        case .pediatric:
            return "Safe pediatric dosing. Always double-check weight in kg."
        case .infusion:
            return "Complex mcg/kg/min drips and continuous infusions."
        case .conversion:
            return "Unit conversions, ratios, and the dimensional analysis foundation."
        case .advanced:
            return "BSA, dilutions, alligation & advanced pharmacy calculations (NAPLEX ready)."
        }
    }
    
    var position: CGPoint {
        // Normalized positions on a 1000x1400 map canvas
        switch self {
        case .oral: return CGPoint(x: 220, y: 280)
        case .ivFlow: return CGPoint(x: 480, y: 220)
        case .drip: return CGPoint(x: 720, y: 300)
        case .weight: return CGPoint(x: 300, y: 520)
        case .pediatric: return CGPoint(x: 580, y: 480)
        case .infusion: return CGPoint(x: 780, y: 580)
        case .conversion: return CGPoint(x: 180, y: 720)
        case .advanced: return CGPoint(x: 520, y: 780)
        }
    }
    
    var requiredStarsToUnlock: Int {
        switch self {
        case .oral, .conversion: return 0
        case .ivFlow, .weight: return 2
        case .drip, .pediatric: return 4
        case .infusion: return 7
        case .advanced: return 10
        }
    }
}

struct MapRegion: Identifiable, Hashable {
    let type: RegionType
    var id: String { type.id }
    
    var title: String { type.rawValue }
    var icon: String { type.icon }
    var color: Color { type.accentColor }
    var description: String { type.description }
    var position: CGPoint { type.position }
}

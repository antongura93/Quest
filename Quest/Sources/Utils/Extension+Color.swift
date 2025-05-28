

import Foundation
import SwiftUI

extension Color {
    init(r: Double, g: Double, b: Double, opacity: Double = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, opacity: opacity)
    }
    
    init(r: Int, g: Int, b: Int, opacity: Double = 1.0) {
        self.init(red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: opacity)
    }
}

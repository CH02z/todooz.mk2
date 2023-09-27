//
//  Extenstions.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 27.09.23.
//

import Foundation
import SwiftUI



extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Date {
    
    // Checking Whether the Date is Today
    var isToday: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.isDateInToday(self)
    }
    // Checking if the date is Past Hours
    var isPast: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.compare(self, to: .init(), toGranularity: .minute) == .orderedAscending
    }
    // Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CEST")!
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

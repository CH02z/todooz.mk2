//
//  Extensions.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import Foundation
import SwiftUI

extension View {
    /// Custom Spacers
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Checking Two dates are same
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

//Task .sleep in Seconds----------------------------------------------------------------------------
extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}



//Date Extensions---------------------------------------------------------------------------------------
extension Date {
    
    // Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CEST")!
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func removeTimeStamp() -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        guard let date = calendar.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }
    
    // Checking Whether the Date is Today
    var isToday: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.isDateInToday(self)
    }
    
    // Checking if the date is Same Hour
    var isSameHour: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    // Checking if the date is Past Hours
    var isPast: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
    
    
}


func getSubtractedDate(unit: String, value: Int, inputDate: Date) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "CEST")!
    
    if unit == "Days" {
        return calendar.date(byAdding: .day, value: -value, to: inputDate)!
    }
    
    if unit == "Hours" {
        return calendar.date(byAdding: .hour, value: -value, to: inputDate)!
    }
    
    if unit == "Minutes" {
        //print("return date subtrcted by \(value) minutes")
        //print(calendar.date(byAdding: .minute, value: -value, to: inputDate)!)
        return calendar.date(byAdding: .minute, value: -value, to: inputDate)!
        
    }
    
    return Date()
    
}







//Color Extensions--------------------------------------------------------------------------------------------------
//From Color to Hex
//Example usage: var color: Color
//color.toHex() --> String

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}



// From Hex to Color:
// Example usage: .backround(Color(hex: HexString))


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




//Localization----------------------------------------------

enum Language: String {
    case english = "en"
    case german = "de"
}

extension String {

    /// Localizes a string using given language from Language enum.
    /// - parameter language: The language that will be used to localized string.
    /// - Returns: localized string.
    func localized(_ language: Language) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }

    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}

//
//  AppIconService.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 24.09.23.
//

import Foundation
import SwiftUI

enum AppIcon: String, CaseIterable, Identifiable {
    case purple = "AppIcon-purple"
    case orange = "AppIcon-orange"
    case blue = "AppIcon-blue"
    case green = "AppIcon-green"
    case red = "AppIcon-red"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .purple:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .purple:
            return "Default purple app icon"
        case .orange:
            return "organge app icon"
        case .blue:
            return "blue app icon"
        case .green:
            return "green app icon"
        case .red:
            return "red app icon"
        }
        
    }

}


final class ChangeAppIconHandler: ObservableObject {


    @Published private(set) var selectedAppIcon: AppIcon

    init() {
        if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
            selectedAppIcon = appIcon
        } else {
            selectedAppIcon = .purple
        }
    }

    func updateAppIcon(to icon: AppIcon) {
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon

        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                /// No need to update since we're already using this icon.
                return
            }

            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
            } catch {
                /// We're only logging the error here and not actively handling the app icon failure
                /// since it's very unlikely to fail.
                print("Updating icon to \(String(describing: icon.iconName)) failed.")

                /// Restore previous app icon
                selectedAppIcon = previousAppIcon
            }
        }
    }
}

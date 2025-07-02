//
//  Components.swift
//  x-health
//
//  Created by Ahmed Moahmed on 02/02/2025.
//

import Foundation
// Views/Components.swift
import SwiftUI

extension Color {
    static let xHealthBackground = Color.black
    static let xHealthAccent = Color(red: 29/255, green: 185/255, blue: 84/255)
    static let xHealthPrimaryText = Color.white
    static let xHealthSecondaryText = Color.gray
}

extension Color {
    /// Initialize a Color from a hex string (e.g. "#FF0000")
    init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6 else { return nil }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        self.init(red: r, green: g, blue: b)
    }
    
    /// Convert this Color to a hex string.
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let r = Int(red * 255)
            let g = Int(green * 255)
            let b = Int(blue * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        }
        return nil
    }
}

struct HomeButton: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.xHealthPrimaryText)
                .multilineTextAlignment(.leading)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.xHealthSecondaryText)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.xHealthAccent.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.xHealthAccent, lineWidth: 1)
        )
    }
}

struct LogoView: View {
    var body: some View {
        VStack {
            Text("x_healthApp")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.xHealthAccent)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.xHealthAccent, Color.white]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("x_healthApp")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                    )
                )
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 36))
                .foregroundColor(.xHealthAccent)
        }
    }
}

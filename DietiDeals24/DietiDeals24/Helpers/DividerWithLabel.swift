//
//  DividerWithLabel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 14/03/24.
//

import SwiftUI

struct DividerWithLabel: View {
    let label: String
    let padding: CGFloat
    let color: Color
    let isVertical: Bool
    init(label: String, padding: CGFloat = 20, color: Color = .gray, isVertical: Bool = false) {
        self.label = label
        self.padding = padding
        self.color = color
        self.isVertical = isVertical
    }
    private var dividerLine: some View {
        
        return  Divider().background(color).padding(padding)
    }
    var body: some View {
            dividerLine
            Text(label).foregroundColor(color)
            dividerLine
    }

}

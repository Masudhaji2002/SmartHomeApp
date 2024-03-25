//
//  SettingRowView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 18.03.2024.
//

import SwiftUI

struct SettingRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundStyle(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    SettingRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}


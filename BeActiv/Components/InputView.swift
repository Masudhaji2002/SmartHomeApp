//
//  InputView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 16.03.2024.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeHolder: String
    var isSecureField = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            
            Text(title)
                .padding(.leading)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField {
                SecureField(placeHolder, text: $text)
                    .font(.system(size: 14))
                    .frame(height:40)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
                    .padding(3)
            } else {
                TextField(placeHolder, text: $text)
                    .padding(.leading)
                    .font(.system(size: 14))
                    .frame(height:40)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
            }
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email address", placeHolder: "name@example.ru")
}

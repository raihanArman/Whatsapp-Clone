//
//  AuthHeaderView.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 24/07/24.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        HStack {
            Image(.whatsapp)
                .resizable()
                .frame(width: 40, height: 40)
            
            Text("Whatsapp")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    AuthHeaderView()
}

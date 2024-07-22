//
//  SettingsItemView.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 22/07/24.
//

import SwiftUI

struct SettingsItemView: View {
    let item: SettingsItem
    
    var body: some View {
        HStack {
            iconImageView()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            
            Text(item.title)
                .font(.system(size: 18))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func iconImageView() -> some View {
        switch item.imageType {
        case .systemImage:
            Image(systemName: item.imageName)
                .bold()
                .font(.callout)
        case .assetImage:
            Image(item.imageName)
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .padding(3)
        }
    }
}

#Preview {
    SettingsItemView(item: .chats)
}

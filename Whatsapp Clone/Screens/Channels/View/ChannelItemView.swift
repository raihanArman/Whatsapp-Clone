//
//  ChannelItemView.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 22/07/24.
//

import SwiftUI

struct ChannelItemView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 3) {
                titleTextView()
                lastMessagePreview()
            }
        }
    }
    
    private func titleTextView() -> some View {
        HStack {
            Text("Username here")
                .lineLimit(1)
                .bold()
            Spacer()
            Text("5:50 PM")
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessagePreview() -> some View {
        Text("Hey welcome")
            .font(.system(size: 16))
            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ChannelItemView()
}

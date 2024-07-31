//
//  ChatRoomScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 22/07/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    let channel: ChannelItem
    var body: some View {
        MessageListView()
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                TextInputArea()
            }
    }
}

extension ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                Circle()
                    .frame(width: 35, height: 30)
                
                Text(channel.title)
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            
            Button {
                
            } label: {
                Image(systemName: "phone")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomScreen(channel: .placeholder)
    }
}

//
//  ChannelTabScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 22/07/24.
//

import SwiftUI

struct ChannelTabScreen: View {
    @State private var searchText = ""
    @State private var showChatPartnerPicker = false
    @StateObject private var viewModel = ChannelTabViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                archiveButton()
                
                ForEach(0..<3) {_ in
                    NavigationLink {
                        ChatRoomScreen(channel: .placeholder)
                    } label: {
                        ChannelItemView()
                    }
                }
                
                inboxFooterView()
                    .listRowSeparator(.hidden)
            }
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .listStyle(.plain)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .sheet(isPresented: $viewModel.showChatPartnerPickerView) {
                ChatPartnerPickerScreen(onCreate: viewModel.onNewChannelCreation)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if let newChannel = viewModel.newChannel {
                    ChatRoomScreen(channel: newChannel)
                }
            }
        }
    }
}

extension ChannelTabScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button {
                    
                } label: {
                    Label("Select Chats", systemImage: "checkmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            aiButton()
            cameraButton()
            newChatButton()
        }
    }
    
    private func aiButton() -> some View {
        Button {
            
        } label: {
            Image(.circle)
        }
    }
    
    private func newChatButton() -> some View {
        Button {
            viewModel.showChatPartnerPickerView = true
        } label: {
            Image(.plus)
        }
    }
    
    private func cameraButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "camera")
        }
    }

    private func archiveButton() -> some View {
        Button {
            
        } label: {
            Label("Archive", systemImage: "archivebox.fill")
                .bold()
                .padding()
                .foregroundColor(.gray)
        }
    }
    
    private func inboxFooterView() -> some View {
        HStack {
            Image(systemName: "lock.fill")
            (
                Text("Your personal messages are ")
                +
                Text("end-to-end encrypted")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            )
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal)
    }
}

#Preview {
    ChannelTabScreen()
}

//
//  NewGroupSetUpScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 29/07/24.
//

import SwiftUI

struct NewGroupSetUpScreen: View {
    @State private var channelName = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    
    var body: some View {
        List {
            Section {
                channelSetUpHeaderView()
            }
            Section {
                Text("Dissapearing Messagers")
                Text("Group Permissions")
            }
            
            Section {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            } header: {
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstant.maxGroupParticipant
                
                Text("Participant: \(count) of \(maxCount)")
                    .bold()
            }
            .listRowBackground(Color.clear)
            
        }
        .navigationTitle("New Group")
        .toolbar {
            trailingNavItem()
        }
    }
    
    private func channelSetUpHeaderView() -> some View {
        HStack {
            profileImageView()
            
            TextField(
                "ampas",
                text: $channelName,
                prompt: Text("Group Name (optional)"),
                axis: .vertical
            )
        }
    }
    
    private func profileImageView() -> some View {
        Button {
            
        } label: {
            ZStack {
                Image(systemName: "camera.fill")
                    .imageScale(.large)
            }
            .frame(width: 60, height: 60)
            .background(Color(.systemGray6))
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Create") {
                
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
    
}

#Preview {
    NavigationStack {
        NewGroupSetUpScreen(viewModel: ChatPartnerPickerViewModel())
    }
}

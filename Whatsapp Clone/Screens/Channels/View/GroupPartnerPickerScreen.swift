//
//  AddGroupChatPartnersScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 26/07/24.
//

import SwiftUI

struct GroupPartnerPickerScreen: View {
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    @State private var searchText = ""
    
    var body: some View {
        List {
            if viewModel.showSelectedUsers {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            }
            
            Section {
                ForEach(viewModel.users) { item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatPartnerRowView(item)
                    }
                }
            }
            
            if viewModel.isPaginatable {
                loadMoreUsers()
            }
        }
        .animation(.easeInOut, value: viewModel.showSelectedUsers)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always)
            , prompt: "Search name or number")
        .toolbar {
            titleView()
            trailingNavItem()
        }
        
    }
    
    
    private func chatPartnerRowView(_ user: UserItem) -> some View {
        ChatPartnerRowView(user: user) {
            Spacer()
            let isSelected = viewModel.isUserSelected(user)
            let imageView = isSelected ? "checkmark.circle.fill" : "circle"
            let foregroundStyle = isSelected ? Color.blue : Color(.systemGray4)
            Image(systemName: imageView)
                .foregroundStyle(foregroundStyle)
                .imageScale(.large)
        }
    }
    
    private func loadMoreUsers() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
    
}

extension GroupPartnerPickerScreen {
    @ToolbarContentBuilder
    private func titleView() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Add participant")
                    .bold()
                
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstant.maxGroupParticipant
                
                Text("\(count)/\(maxCount)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Next") {
                viewModel.navStack.append(.setupGroupChat)
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
    }
}

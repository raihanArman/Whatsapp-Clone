//
//  ChatPartnerPickerScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 25/07/24.
//

import SwiftUI

struct ChatPartnerPickerScreen: View {
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ChatPartnerPickerOption.allCases) { item in
                    HeaderView(item: item)
                }
                
                Section {
                    ForEach(0..<12) { _ in
                        ChatPartnerRowView(user: .placeholder)
                    }
                } header: {
                    Text("Contact on Whatsapp")
                        .textCase(nil)
                        .bold()
                }
            }
            .searchable(text: $searchText, prompt: "Search name or number")
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                trailingNavItem()
            }
        }
    }
}

extension ChatPartnerPickerScreen {
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            cancelButton()
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
}

extension ChatPartnerPickerScreen {
    private struct HeaderView: View {
        let item: ChatPartnerPickerOption
        
        var body: some View {
            Button {
                
            } label: {
                buttonBody()
            }
        }
        
        private func buttonBody() -> some View {
            HStack {
                Image(systemName: item.imageName)
                    .font(.footnote)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray4))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                Text(item.title)
            }
        }
    }
}

enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newCommunity = "New Community"
    
    var id: String {
        return rawValue
    }
    
    var title: String {
        return rawValue
    }
    
    var imageName: String {
        switch self {
        case .newGroup:
            return "person.2.fill"
        case .newContact:
            return "person.fill.badge.plus"
        case .newCommunity:
            return "person.3.fill"
        }
    }
}

#Preview {
    ChatPartnerPickerScreen()
}

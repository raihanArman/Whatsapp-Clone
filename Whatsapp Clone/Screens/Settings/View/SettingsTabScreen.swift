//
//  SettingsTabScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 22/07/24.
//

import SwiftUI

struct SettingsTabScreen: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                SettingsHeaderView()
                
                Section {
                    SettingsItemView(item: .broadCastLists)
                    SettingsItemView(item: .starredMessages)
                    SettingsItemView(item: .linkedDevices)
                }
                
                Section {
                    SettingsItemView(item: .account)
                    SettingsItemView(item: .privacy)
                    SettingsItemView(item: .chats)
                    SettingsItemView(item: .notifications)
                    SettingsItemView(item: .storage)
                }
                
                Section {
                    SettingsItemView(item: .help)
                    SettingsItemView(item: .tellFriend)
                }
                
            }
            .navigationTitle("Settings")
            .searchable(text: $searchText)
        }
    }
}

private struct SettingsHeaderView: View {
    var body: some View {
        Section {
            HStack {
                Circle()
                    .frame(width: 55, height: 55)
                
                userInfoTextView()
            }
            
            SettingsItemView(item: .avatar)
        }
    }
    
    private func userInfoTextView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Fa User 12")
                    .font(.title2)
                
                Spacer()
                
                Image(.qrcode)
                    .renderingMode(.template)
                    .padding(5)
                    .foregroundStyle(.blue)
                    .background(Color(.systemGray5))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

            }
            
            Text("Hey there I am using Whatsapp")
                .foregroundStyle(.gray)
                .font(.callout)
        }
        .lineLimit(1)
        
    }
}

#Preview {
    SettingsTabScreen()
}

//
//  ChatPartnerRowView.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 25/07/24.
//

import SwiftUI

struct ChatPartnerRowView: View {
    let user: UserItem
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .bold()
                    .foregroundStyle(.black)
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    ChatPartnerRowView(user: .placeholder)
}

//
//  BubbleTailView.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 23/07/24.
//

import SwiftUI

struct BubbleTailView: View {
    var direction: MessageDirection
    private var backgroundColor: Color {
        return direction == .received ? .bubbleWhite : .bubbleGreen
    }
    
    var body: some View {
        Image(direction == .sent ? .outgoingTail : .incomingTail)
            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
            .resizable()
            .frame(width: 10, height: 10)
            .offset(y: 3)
            .foregroundColor(backgroundColor)
    }
}

#Preview {
    ScrollView {
        BubbleTailView(direction: .received)
        BubbleTailView(direction: .sent)
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.1))
}

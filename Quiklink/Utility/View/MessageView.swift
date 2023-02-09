//
//  MessageView.swift
//  Quiklink
//
//  Created by Matt Bommer on 2/7/23.
//

import SwiftUI
import Foundation

struct MessageView: View {
    @EnvironmentObject var modalStore: ModalStore
    
    var message: String
    var type: MessageType = .ok
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(Color(uiColor: .brandWhite))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(type.color))
        }
        .padding([.leading, .trailing], 12)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                modalStore.dismiss()
            }
        }
    }
    
    enum MessageType {
        case ok
        case critical
        case warning
        
        var color: Color {
            switch self {
            case .ok:
                return Color(uiColor: .brandGreen)
            case .critical:
                return Color(uiColor: .brandRed)
            case .warning:
                return Color(uiColor: .brandYellow)
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: "Sample")
    }
}

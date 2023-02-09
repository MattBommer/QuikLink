//
//  StretchButton.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI

struct StretchButton<Label: View>: View {
    var action: () -> Void
    var label: () -> Label
    
    var body: some View {
        Button {
            action()
        } label: {
            label()
                .frame(maxWidth: .infinity)
        }
        .padding([.top, .bottom])
        .cornerRadius(8)
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StretchButton {
            print()
        } label: {
            Text("Login")
        }
    }
}

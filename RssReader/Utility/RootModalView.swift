//
//  PopupModal.swift
//  RssReader
//
//  Created by Matt Bommer on 1/19/23.
//

import SwiftUI

struct RootModalView<T: View>: View {
    @StateObject private var modalStore = ModalStore()
    
    var backgroundColor: Color?
    @State var contentView: () -> T

    var body: some View {
        ZStack {
            contentView()
            if modalStore.isPresented {
                Group {
                    backgroundColor
                    modalStore.contentView
                }
                .ignoresSafeArea()
            }
        }
        .environmentObject(modalStore)
    }
}

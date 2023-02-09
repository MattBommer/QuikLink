//
//  RootModalView.swift
//  Quiklink
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
                    backgroundColor?
                        .isHidden(!modalStore.dimBackground)
                        .onTapGesture {
                            modalStore.dismiss()
                        }
                    modalStore.contentView
                }
                .ignoresSafeArea(modalStore.ignoreSafeArea ? .all : [])
            }
        }
        .environmentObject(modalStore)
    }
}

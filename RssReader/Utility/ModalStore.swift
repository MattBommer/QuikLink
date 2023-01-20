//
//  ModalStore.swift
//  RssReader
//
//  Created by Matt Bommer on 1/19/23.
//

import UIKit
import SwiftUI

class ModalStore: ObservableObject {
    
    @Published var contentView: AnyView = AnyView(EmptyView())
    @Published var isPresented: Bool = false
    
    func present<ContentView: View>(@ViewBuilder view: () -> ContentView) {
        contentView = AnyView(view())
        isPresented = true
    }
    
    func dismiss() {
        contentView = AnyView(EmptyView())
        isPresented = false
    }
}


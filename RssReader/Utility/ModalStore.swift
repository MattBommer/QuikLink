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
    @Published var dimBackground = true
    @Published var ignoreSafeArea = true
    @Published var isPresented: Bool = false
    
    func present<ContentView: View>(@ViewBuilder view: () -> ContentView, dim: Bool = true, ignoreSafeArea: Bool = true) {
        contentView = AnyView(view())
        dimBackground = dim
        self.ignoreSafeArea = ignoreSafeArea
        isPresented = true
    }
    
    func dismiss() {
        contentView = AnyView(EmptyView())
        isPresented = false
    }
}


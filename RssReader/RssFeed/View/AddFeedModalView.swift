//
//  AddFeedModalView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/31/23.
//

import SwiftUI

struct AddFeedModalView: View {
    @State var feedUrl: String = ""
    @EnvironmentObject var modalStore: ModalStore
    @EnvironmentObject var feedViewModel: RSSFeedViewModel
    
    var body: some View {
        VStack {
            Text("Add a Feed")
            TextField("Insert feed url", text: $feedUrl)
            HStack {
                StretchButton {
                    Task {
                        try await feedViewModel.addFeed(feedUrl)
                    }
                } label: {
                    Text("Add")
                }
                .background(Color(uiColor: .brandGreen))
                .cornerRadius(8)
                
                StretchButton {
                    modalStore.dismiss()
                } label: {
                    Text("Cancel")
                }
                .background(Color(uiColor: .brandRed))
                .cornerRadius(8)

            }
        }
    }
}

struct AddFeedModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedModalView()
    }
}

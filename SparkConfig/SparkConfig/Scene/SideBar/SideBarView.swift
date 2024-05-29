//
//  SideBarView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

struct SideBarView: View {

    // MARK: - Properties

    let entries = Entry.allCases
    @State var selectedEntry: Entry?

    // MARK: - View
    
    var body: some View {

        NavigationSplitView {
            List(self.entries, selection: self.$selectedEntry) { entry in
                Label(entry.name, systemImage: entry.systemImage)
                    .tag(entry)
            }
        } detail: {
            switch self.selectedEntry {
            case .repositories:
                RepositoriesView()
            case .none:
                EmptyView()
            }
        }
    }
}

#Preview {
    SideBarView()
}

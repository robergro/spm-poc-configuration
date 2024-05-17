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
        List {
            ForEach(self.entries, id: \.rawValue) { entry in
                NavigationLink {
                    switch entry {
                    case .repositories:
                        RepositoriesView()
                    }
                } label: {
                    Label(entry.name, systemImage: entry.systemImage)
                }
            }
        }
    }
}

#Preview {
    SideBarView()
}

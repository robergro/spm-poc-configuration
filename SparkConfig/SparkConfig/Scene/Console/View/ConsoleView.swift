//
//  ConsoleView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import SwiftUI

struct ConsoleView: View {

    // MARK: - Properties

    @Bindable private var viewModel = ConsoleViewModel()

    // MARK: - View
    
    var body: some View {
        VSplitView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    Button {
                        self.viewModel.isConsoleVisible.toggle()
                    } label: {
                        Image(systemName: "rectangle.bottomthird.inset.filled")
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(.plain)
                    .padding(4)
                    .padding(.trailing, 8)
                }

                Divider()
                    .background(Color.black)

                if self.viewModel.isConsoleVisible {
                    ScrollView {
                        ScrollViewReader { reader in
                            LazyVStack {
                                ForEach(
                                    self.viewModel.searchResults,
                                    id: \.identifier
                                ) { log in
                                    Text(log.value)
                                        .foregroundStyle(log.type.color)
                                        .bold(log.style.bold)
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .onChange(of: Console.shared.logs.count, initial: false) { _, newValue in
                                withAnimation {
                                    reader.scrollTo(newValue - 1, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .defaultScrollAnchor(.bottom)
                    .padding(4)

                    HStack {
                        Spacer()

                        TextField("Filter", text: self.$viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)

                        Button {
                            Console.shared.clear()
                        } label: {
                            Image(systemName: "trash")
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(.plain)
                        .padding(4)
                        .padding(.trailing, 8)
                    }
                    .padding(.bottom, 4)
                }
            }
        }
    }
}

private extension Animation {

    static var custom: Animation {
        return Animation.easeOut(duration: 0.4)
    }
}

#Preview {
    ConsoleView()
}

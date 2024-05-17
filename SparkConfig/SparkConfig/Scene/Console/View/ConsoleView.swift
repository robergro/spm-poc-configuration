//
//  ConsoleView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import SwiftUI

struct ConsoleView: View {

    // MARK: - Properties

    @State private var isConsoleVisible = true

    // MARK: - View
    
    var body: some View {
        VSplitView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    Button {
                        self.isConsoleVisible.toggle()
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

                if self.isConsoleVisible {
                    ScrollView {
                        ForEach(
                            Console.shared.logs,
                            id: \.identifier
                        ) { log in
                            Text(log.value)
                                .foregroundStyle(log.type.color)
                                .bold(log.style.bold)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(4)

                    Divider()
                        .background(Color.black)

                    HStack {
                        Spacer()

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

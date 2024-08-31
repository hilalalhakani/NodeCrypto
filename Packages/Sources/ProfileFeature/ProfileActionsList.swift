//
//  File.swift
//
//
//  Created by Hilal Hakkani on 27/04/2024.
//

import Foundation
import NodeCryptoCore
import SwiftUI

public struct ProfileActionsList: View {
    let editButtonPressed: () -> Void
    let shareButtonPressed: () -> Void
    let replaceButtonPressed: () -> Void
    let removeButtonPressed: () -> Void

    public init(
        editButtonPressed: @escaping () -> Void,
        shareButtonPressed: @escaping () -> Void,
        replaceButtonPressed: @escaping () -> Void,
        removeButtonPressed: @escaping () -> Void
    ) {
        self.editButtonPressed = editButtonPressed
        self.shareButtonPressed = shareButtonPressed
        self.replaceButtonPressed = replaceButtonPressed
        self.removeButtonPressed = removeButtonPressed
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ProfileActionItem(
                title: "Edit profile",
                icon: Image(systemName: "pencil"),
                action: editButtonPressed
            )
            .foregroundStyle(
                Color.primary1,
                Color.primary1
            )

            Divider()
                .foregroundStyle(.gray)

            ProfileActionItem(
                title: "Share",
                icon: Image(systemName: "square.and.arrow.up"),
                action: shareButtonPressed
            )
            .foregroundStyle(
                Color.neutral2,
                Color.neutral4
            )

            ProfileActionItem(
                title: "Replace cover",
                icon: Image(systemName: "photo"),
                action: replaceButtonPressed
            )
            .foregroundStyle(
                Color.neutral2,
                Color.neutral4
            )

            ProfileActionItem(
                title: "Remove cover",
                icon: Image(systemName: "xmark"),
                action: removeButtonPressed
            )
            .foregroundStyle(
                Color.neutral2,
                Color.neutral4
            )
        }
        .padding([.vertical, .horizontal], 25)
        .background(Color.neutral8)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.vertical, 108)
        .padding(.horizontal, 25)
        .fixedSize()
    }
}

struct ProfileActionItem: View {
    let title: String
    let icon: Image
    let action: () -> Void
    var body: some View {

        Button {
            action()
        } label: {
            HStack {

                Text(title)
                    .font(.init(FontName.dmSansBold, size: 16))
                    .foregroundStyle(.primary)

                Spacer()

                icon
                    .foregroundStyle(.secondary)

            }
        }
        .frame(minWidth: 200)
    }
}

#Preview {
    ProfileActionsList(
        editButtonPressed: {},
        shareButtonPressed: {},
        replaceButtonPressed: {},
        removeButtonPressed: {}
    )
}

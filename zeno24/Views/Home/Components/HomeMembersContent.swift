import SwiftUI

struct HomeMembersContent: View {
    let members: [MarkerModel]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(members.enumerated()), id: \.element.id) { index, member in
                HomeMemberRow(member: member)
                if index < members.count - 1 {
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(Color(hex: 0xF2F5F9))
                            .frame(width: 253, height: 1)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

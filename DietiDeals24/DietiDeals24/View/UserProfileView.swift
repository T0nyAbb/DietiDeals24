//
//  UserProfileView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 09/04/24.
//

import SwiftUI

struct UserProfileView: View {
    
    @State var user: User?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ImageView(pictureUrl: user?.profilePicture, isProfilePicture: true)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
                .offset(y: -50)
                .padding(.bottom, -130)
                .frame(width: 300, height: 300)
            VStack(alignment: .leading) {
                Text("\(user?.firstName! ?? "") \(user?.lastName! ?? "")")
                    .font(.title)
                HStack {
                    Text(user?.website ?? "No website")
                    Spacer()
                    Text(user?.geographicArea ?? "Unknown")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                Text(user?.bio ?? "No description")
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    UserProfileView(user: User(id: 0, firstName: "mario", lastName: "rossi", username: "prova@email", password: "", bio: "Ciao sono io", website: "www.amazon.com", social: "", geographicArea: "Italy", google: nil, facebook: nil, apple: nil, profilePicture: nil, iban: nil, vatNumber: nil, nationalInsuranceNumber: nil))
}

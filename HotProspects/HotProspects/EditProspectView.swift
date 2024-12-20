//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Mac on 22/11/2024.
//

import SwiftUI

struct EditProspectView: View {
    @Bindable var prospect: Prospect
    
    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
                .textContentType(.name)
            
            TextField("Email", text: $prospect.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
        }
        .navigationTitle("Edit Prospect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditProspectView(prospect: Prospect(name: "Jane Doe", emailAddress: "jane.doe@example.com", isContacted: true))
        .modelContainer(for: Prospect.self)
}

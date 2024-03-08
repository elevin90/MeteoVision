//
//  CitiesListRow.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import SwiftUI

struct CityListRow: View {
  let cityTitle: String
  
  var body: some View {
    HStack {
      Text(cityTitle)
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .foregroundColor(.defaultText)
      Spacer()
    }
    .padding(.vertical, 6)
    .contentShape(Rectangle())
  }
}

#Preview {
  CityListRow(cityTitle: "London")
}

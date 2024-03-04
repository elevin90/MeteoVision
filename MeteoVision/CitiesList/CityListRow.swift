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
      Text(cityTitle)
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .foregroundColor(.defaultText)
        .padding(.vertical, 6)
    }
}

#Preview {
  CityListRow(cityTitle: "London")
}

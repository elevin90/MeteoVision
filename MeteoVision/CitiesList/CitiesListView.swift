//
//  ContentView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import SwiftUI
import TipKit

struct CitiesListView: View {
  @StateObject private var viewModel = CitiesListViewModel()
  private let tipView = CitiesListTipView()
  var onTap: ((String) -> Void)?
  
  var body: some View {
    searchBar
    if viewModel.searchQuery.isEmpty, viewModel.searchResults.isEmpty {
      ContentUnavailableView(
        "Start typing or select your current location",
        systemImage: "binoculars.fill"
      )
    } else {
      searchList
    }
  }
  
  private var searchList: some View {
      List {
        ForEach(viewModel.searchResults, id: \.self) { title in
            CityListRow(cityTitle: title)
        }
    }
    .overlay {
      if viewModel.searchQuery.count > 1 && viewModel.searchResults.isEmpty {
        /// In case there aren't any search results, we can
        /// show the new content unavailable view.
        ContentUnavailableView.search
      }
    }
  }
  
  private var searchField: some View {
    HStack {
      Image(systemName: "magnifyingglass").foregroundColor(.secondary)
      TextField("Search for city", text: $viewModel.searchQuery)
      Button(action: {
        viewModel.searchQuery = ""
      }) {
        Image(systemName: "xmark.circle.fill")
          .foregroundColor(.secondary)
          .opacity(viewModel.searchQuery == "" ? 0 : 1)
      }
    }
    .padding(8)
    .background(Color(.secondarySystemBackground))
    .cornerRadius(8)
  }
  
  private var locationButton: some View {
    Button(action: {
      UIApplication.shared.endEditing(true)
    }, label: {
      Image(systemName: "location.square.fill")
    })
    .font(.largeTitle)
    .popoverTip(tipView, arrowEdge: .top)
    .onTapGesture {
      tipView.invalidate(reason: .actionPerformed)
    }
  }
  
  private var searchBar: some View {
    HStack {
      searchField
      locationButton
    }
    .padding()
  }
}

#Preview {
  CitiesListView()
}

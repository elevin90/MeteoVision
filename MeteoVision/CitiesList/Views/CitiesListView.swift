//
//  ContentView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import SwiftUI
import TipKit
import CoreLocationUI

struct CitiesListView: View {
  @StateObject private var viewModel: CitiesListViewModel
  private let tipView = CitiesListTipView()

  init(viewModel: CitiesListViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
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
            .onTapGesture {
            Task {
              await viewModel.geocodeCoordinatesFor(title)
            }
          }
        }
    }
    .overlay {
      /// In case there aren't any search results, we can
      /// show the new content unavailable view.
      if viewModel.searchQuery.count > 1 && viewModel.searchResults.isEmpty {
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
    .padding(12)
    .background(Color(.secondarySystemBackground))
    .cornerRadius(8)
  }
  
  private var searchBar: some View {
    HStack {
      searchField
      LocationButton(.currentLocation) {
        viewModel.requestLocation()
        tipView.invalidate(reason: .actionPerformed)
      }
      .symbolVariant(.fill)
      .labelStyle(.iconOnly)
    }
    .padding()
  }
}

#Preview {
  CitiesListView(viewModel: CitiesListViewModel(showType: .citySearch))
}

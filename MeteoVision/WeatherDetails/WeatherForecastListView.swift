//
//  WeatherForecastListView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 6.03.24.
//

import SwiftUI

struct WeatherIconView: View {
  let statusCode: Int
  
  var body: some View {
    if Range(200...299).contains(statusCode) {
      Image(systemName: "cloud.bolt")
    } else if Range(300...599).contains(statusCode) {
      Image(systemName: "cloud.rain")
    } else if Range(600...699).contains(statusCode) {
      Image(systemName: "cloud.snow")
    } else if Range(700...799).contains(statusCode) {
      Image(systemName: "cloud.fog")
    } else if statusCode == 800 {
      Image(systemName: "sun.max")
    } else if statusCode == 801 {
      Image(systemName: "cloud.sun")
    } else {
      Image(systemName: "cloud")
    }
  }
}

struct WeatherForecastListView: View {
  @State private var viewModel: WeatherForecastListViewModel
  
  init(viewModel: WeatherForecastListViewModel) {
    self.viewModel = viewModel
  }
  
  var currentWeatherView: some View {
    VStack {
      HStack {
        Image(systemName: "building.2.fill")
          .font(.title3)
        Text(viewModel.currentWeatcher?.city ?? "Unknown location")
          .font(.title2)
        Spacer()
      }
      if let currentWeatcher = viewModel.currentWeatcher,
         let condition = currentWeatcher.conditions.first {
          Text(condition.condition)
          Text(condition.description)
          HStack {
            Text("\(currentWeatcher.details.temperature)°")
            WeatherIconView(statusCode: condition.id)
          }
        }
      }
    .padding()
  }
  
    var body: some View {
      NavigationStack {
        List {
          currentWeatherView
        }
        .onAppear {
          Task {
           await viewModel.fetchWeatherDetails()
          }
        }
        .navigationTitle("")
      }
    }
}

#Preview {
  WeatherForecastListView(viewModel: WeatherForecastListViewModel(locationCoordinates: .init(latitude: 10, longitude: 11)))
}

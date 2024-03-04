//
//  CitiesListTipView.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 4.03.24.
//

import TipKit

struct CitiesListTipView: Tip {
  
  var title: Text {
    Text("Search in my location!")
  }
  
  var message: Text? {
    Text("You can quickly get the weather in your location")
  }
  
  var image: Image? {
    Image(systemName: "location.fill")
  }
  
  var options: [TipOption] {
    [Tip.MaxDisplayCount(1)]
  }
}

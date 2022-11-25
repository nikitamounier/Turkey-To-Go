import ComposableArchitecture
import DetailFeature
import SwiftUI


@main
struct DetailFeaturePreview: App {
  var body: some Scene {
    WindowGroup {
      DetailView(
        store: Store(
          initialState: DetailFeature.State(
            turkey: .init(
              kind: "Heritage Turkey",
              brand: "British Turkeys LLC",
              imageName: "001",
              preparation: .roasted,
              grams: 800
            )
          ),
          reducer: DetailFeature()
        )
      )
    }
  }
}



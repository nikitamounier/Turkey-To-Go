import ComposableArchitecture
import DetailFeature
import SwiftUI


@main
struct DetailFeaturePreview: App {
  let store = StoreOf<DetailFeature>(
    initialState: .init(turkey: .init(
        kind: "Heritage Turkey",
        brand: "British Turkeys LLC",
        imageName: "001",
        preparation: .roasted,
        grams: 800
      )),
    reducer: DetailFeature().dependency(\.openAI, .liveValue)
  )
  
  var body: some Scene {
    WindowGroup {
      DetailView(store: store)
    }
  }
}

import ComposableArchitecture
import DetailFeature
import SwiftUI

@main
struct DetailFeature: App {
    let store = StoreOf(initialState: DetailFeature.State(), reducer: DetailFeature())
  
    var body: some Scene {
        WindowGroup {
            DetailView()
        }
    }
}

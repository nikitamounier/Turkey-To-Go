import ShoppingFeature
import ComposableArchitecture
import SwiftUI

@main
struct Turkey_To_GoApp: App {
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ShoppingView(
              store: .init(initialState: .init(), reducer: ShoppingFeature())
            )
          }
        }
    }
}

import ComposableArchitecture
import SwiftUI
import ShoppingFeature

public struct AppFeature: ReducerProtocol {
  public struct State: Equatable {
    public var shopping: ShoppingFeature.State
    // var profile: ProfileFeature.State
     
    public init(shopping: ShoppingFeature.State = .init()) {
      self.shopping = shopping
    }
  }
   
  public enum Action: Equatable {
    case shopping(ShoppingFeature.Action)
    // case profile(ProfileFeature.Action)
  }
   
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.shopping, action: /Action.shopping) {
      ShoppingFeature()
    }
  }
   
  public init() {}
}
 
public struct AppView: View {
  let store: StoreOf<AppFeature>
   
  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }
  
  public var body: some View {
    TabView {
      ShoppingView(store: store.scope(state: \.shopping, action: AppFeature.Action.shopping))
    }
  }
}

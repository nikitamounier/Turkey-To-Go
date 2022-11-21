import ComposableArchitecture
import SharedModels
import SwiftUI

public struct ShoppingFeature: ReducerProtocol {
  public struct State: Equatable {
    public var turkeys: IdentifiedArrayOf<Turkey> = .allTurkeys
  }
  
  public enum DetailAction: Equatable {}
  
  public enum Action: Equatable {
    case detail(id: Turkey.ID, action: DetailAction)
    case remove(at: IndexSet)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case let .remove(at: offsets):
        state.turkeys.remove(atOffsets: offsets)
        return .none
        
      case .detail:
        return .none
      }
    }
    .forEach(\.turkeys, action: /Action.detail(id:action:)) {
      EmptyReducer()
      // DetailReducer()
    }
  }
}

public struct ShoppingView: View {
  public let store: StoreOf<ShoppingFeature>
  
  public init(store: StoreOf<ShoppingFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: \.turkeys) { viewStore in
      List {
        ForEachStore(
          self.store.scope(state: \.turkeys, action: ShoppingFeature.Action.detail(id:action:)
          )) { detailStore in
            WithViewStore(detailStore, observe: { $0 }) { detailViewStore in
              NavigationLink(
                destination: DetailView(store: detailStore)
              ) {
                HStack {
                  Image(detailViewStore.imageName)
                  VStack(alignment: .leading) {
                    HStack {
                      Text(detailViewStore.kind)
                        .font(.headline)
                      Spacer()
                      Text("\(detailViewStore.grams) g")
                    }
                    Text(detailViewStore.brand)
                      .font(.callout)
                  }
                }
              }
            }
          }
        .onDelete { indexSet in
          viewStore.send(.remove(at: indexSet))
        }
      }
      .navigationTitle("Turkey To-Go")
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  
}

struct DetailView: View {
  init(store: Store<Turkey, ShoppingFeature.DetailAction>) {}
  
  var body: some View {
    Text("Hi")
  }
}


struct ShoppingView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ShoppingView(store: .init(initialState: .init(), reducer: ShoppingFeature()))
    }
  }
}
















extension IdentifiedArray where Element == Turkey, ID == Turkey.ID {
  static let allTurkeys: Self = [
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 800),
    Turkey(kind: "Wild Turkey", brand: "Best Thanksgiving LLC.", imageName: "002", preparation: .frozen, grams: 500),
    Turkey(kind: "Free-Range Turkey", brand: "Pasture Life Co.", imageName: "003", preparation: .roasted, grams: 800),
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 200),
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 200),
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 200),
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 200),
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 200),
    Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 200)
  ]
}

import ComposableArchitecture
import DetailFeature
import struct IdentifiedCollections.IdentifiedArray
import SharedModels
import SwiftUI

public struct ShoppingFeature: ReducerProtocol {
  public struct State: Equatable {
    public var turkeyRows: IdentifiedArrayOf<DetailFeature.State>
    
    public init(turkeyRows: IdentifiedArrayOf<DetailFeature.State> = .allDetails) {
      self.turkeyRows = turkeyRows
    }
  }
  
  public enum Action: Equatable {
    case detail(id: DetailFeature.State.ID, action: DetailFeature.Action)
    case remove(at: IndexSet)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case let .remove(at: offsets):
        state.turkeyRows.remove(atOffsets: offsets)
        return .none
        
      case .detail:
        return .none
      }
    }
    .forEach(\.turkeyRows, action: /Action.detail(id:action:)) {
      DetailFeature()
    }
  }
  
  public init() {}
}

public struct ShoppingView: View {
  public let store: StoreOf<ShoppingFeature>
  
  public init(store: StoreOf<ShoppingFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: \.turkeyRows) { viewStore in
      List {
        ForEachStore(
          self.store.scope(
            state: \.turkeyRows, action: ShoppingFeature.Action.detail(id:action:))) { detailStore in
              WithViewStore(detailStore, observe: { $0 }) { detailViewStore in
                NavigationLink(
                  destination: DetailView(store: detailStore)
                ) {
                  HStack {
                    Image(detailViewStore.turkey.imageName, bundle: Bundle.module)
                      .resizable()
                      .scaledToFit()
                      .cornerRadius(15)
                    VStack(alignment: .leading) {
                      HStack {
                        Text(detailViewStore.turkey.kind)
                          .font(.headline)
                        Spacer()
                        Text("\(detailViewStore.turkey.grams) g")
                      }
                      Text(detailViewStore.turkey.brand)
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


struct ShoppingView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ShoppingView(store: .init(initialState: .init(), reducer: ShoppingFeature()))
    }
  }
}



public extension IdentifiedArray where Element == DetailFeature.State, ID == DetailFeature.State.ID {
  static let allDetails: Self = [
    .init(turkey: Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "001", preparation: .roasted, grams: 800)),
    .init(turkey: Turkey(kind: "Wild Turkey", brand: "Best Thanksgiving LLC.", imageName: "002", preparation: .sliced, grams: 500)),
    .init(turkey: Turkey(kind: "Free-Range Turkey", brand: "Pasture Life Co.", imageName: "003", preparation: .roasted, grams: 800)),
    .init(turkey: Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "004", preparation: .frozen, grams: 200)),
    .init(turkey: Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "005", preparation: .roasted, grams: 200)),
    .init(turkey: Turkey(kind: "Heritage Turkey", brand: "British Turkeys", imageName: "006", preparation: .roasted, grams: 200))
  ]
  
}

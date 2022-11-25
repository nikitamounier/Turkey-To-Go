import ComposableArchitecture
import OpenAIClient
import SharedModels
import SwiftUI
import Foundation

public struct DetailFeature: ReducerProtocol {
  public struct State: Identifiable, Equatable {
    public var id: Turkey.ID { turkey.id }
    public let turkey: Turkey
    public var description: String?
    public var isFetchingDescription: Bool = false
    
    public init(turkey: Turkey, description: String? = nil, isFetchingDescription: Bool = false) {
      self.turkey = turkey
      self.description = description
      self.isFetchingDescription = isFetchingDescription
    }
  }
  
  public enum Action: Equatable {
    case getDescription
    case descriptionResponse(TaskResult<String>)
    case cancelButtonTapped
  }
  
  @Dependency(\.openAI) var openAI
  
  enum CancelID {}
  
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      
    case .getDescription:
      state.isFetchingDescription = true
      
      return .task {
        let response = await TaskResult {
          try await openAI.generateDescription()
        }
        return .descriptionResponse(response)
      }
      .cancellable(id: CancelID.self)
      
    case let .descriptionResponse(.success(description)):
      state.description = description
      state.isFetchingDescription = false
      
      return .none
      
    case .descriptionResponse(.failure):
      state.description = "Something went wrong! Try again by pressing the refresh button. If it still doesn't work, this turkey just isn't for you."
      state.isFetchingDescription = false
      
      return .none
      
    case .cancelButtonTapped:
      state.isFetchingDescription = false
      
      return .cancel(id: CancelID.self)
    }
  }
  
  public init() {}
}

public struct DetailView: View {
  let store: StoreOf<DetailFeature>
  
  public init(store: StoreOf<DetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Form {
        Section {
          HStack {
            Image(viewStore.turkey.imageName, bundle: Bundle.module)
              .resizable()
              .scaledToFit()
              .cornerRadius(10)
            VStack(alignment: .leading) {
              Text("• **Brand**: \(viewStore.turkey.brand)")
              Text("• **Preparation**: \(viewStore.turkey.preparation.description)")
              Text("• **Weight**: \(viewStore.turkey.grams) grams")
            }
          }
        }
        Section {
          if viewStore.isFetchingDescription {
            ProgressView()
            Button(action: { viewStore.send(.cancelButtonTapped)}) {
              Text("Cancel")
            }
          } else {
            Text(viewStore.description ?? "")
            Button(action: { viewStore.send(.getDescription)}) {
              Text("Refresh Description")
            }
          }
        }
        
      }
      .navigationTitle(viewStore.turkey.kind)
      .task {
        await viewStore.send(.getDescription).finish()
      }
    }
  }
}

struct DetailFeature_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(
        store: .init(
          initialState: .init(
            turkey: Turkey(
              kind: "Heritage Turkey",
              brand: "British Turkeys LLC",
              imageName: "001",
              preparation: .roasted,
              grams: 800
            ),
            isFetchingDescription: true
          ),
          reducer: DetailFeature()
            .dependency(
              \.openAI,
               .init(generateDescription: { "Happy thanksgiving! "})
            )
        )
      )
    }
  }
}

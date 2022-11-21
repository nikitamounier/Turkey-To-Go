import Foundation

public struct Turkey: Equatable, Identifiable {
  public let id = UUID()
  
  public let kind: String
  public let brand: String
  public let imageName: String
  public let preparation: Preparation
  public let grams: Int
  
  public init(kind: String, brand: String, imageName: String, preparation: Preparation, grams: Int) {
    self.kind = kind
    self.brand = brand
    self.imageName = imageName
    self.preparation = preparation
    self.grams = grams
  }
  
  public enum Preparation: Equatable, CustomStringConvertible {
    case frozen
    case roasted
    case sliced
    
    public var description: String {
      switch self {
      case .frozen:
        return "Frozen"
      case .roasted:
        return "Roasted"
      case .sliced:
        return "Sliced"
      }
    }
  }
}

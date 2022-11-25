import Dependencies

public struct OpenAIClient {
  public var generateDescription: @Sendable () async throws -> String
  
  public init(generateDescription: @escaping @Sendable () async throws -> String) {
    self.generateDescription = generateDescription
  }
}

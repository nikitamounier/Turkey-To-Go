import Dependencies
import XCTestDynamicOverlay

public extension OpenAIClient {
  static let previewValue: OpenAIClient = Self(
    generateDescription: {
      return "This is a preview!"
    }
  )
}

public extension OpenAIClient {
  static let testValue: OpenAIClient = Self(
    generateDescription: unimplemented("OpenAIClient.generateDescription")
  )
}

import Dependencies
import XCTestDynamicOverlay

public extension OpenAIClient {
  static let previewValue: OpenAIClient = Self(
    generateDescription: {
      return "I'm not a real turkey, this is a preview. Run the app for real!"
    }
  )
}

public extension OpenAIClient {
  static let testValue: OpenAIClient = Self(
    generateDescription: unimplemented("OpenAIClient.generateDescription")
  )
}

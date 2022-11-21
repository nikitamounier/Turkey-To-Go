import Foundation

public struct OpenAIClient {
  public var generateDescription: @Sendable () async throws -> String
}

public extension OpenAIClient {
  static let live = Self(
    generateDescription: {
      let prompt = "Lavishly describe a roasted turkey that just came out of the oven for thanksgiving. Don't mention the other thanksgiving food. Mention the gravy."
      let json = JSONRequest(model: "text-davinci-002", prompt: prompt, max_tokens: 6, temperature: 0)
      
      var request = URLRequest(url: URL(string: "https://api.openai.com/v1/completions")!)
      request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization": "Bearer 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"
      ]
      request.httpMethod = "POST"
      request.httpBody = JSONEncoder().encode(<#T##value: Encodable##Encodable#>)
      let (data, _) = try await URLSession.shared.data(from: .init(string: ))
    }
  )
}

struct JSONRequest: Codable {
  let model: String
  let prompt: String
  let max_tokens: Int
  let temperature: Int
}

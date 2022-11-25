import Dependencies
import Foundation

extension OpenAIClient: DependencyKey {
  static public var liveValue = Self(
    generateDescription: {
      let prompt = "Lavishly describe a roasted turkey that just came out of the oven for thanksgiving. Don't mention the other thanksgiving food. Mention the gravy."
      
      let gpt3 = GPT3Request(model: "text-davinci-002", prompt: prompt, max_tokens: 525, temperature: 0.4, top_p: 1, n: 1, stream: false, logprobs: nil, stop: "")
      
      var request = URLRequest(url: URL(string: "https://api.openai.com/v1/completions")!)
      request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(apiKey)"
      ]
      request.httpMethod = "POST"
      request.httpBody = try JSONEncoder().encode(gpt3)
      
      let (data, _) = try await URLSession.shared.data(for: request)
      let description = try JSONDecoder().decode(GPT3Response.self, from: data).choices[0].text
      
      return String(description.suffix(from: description.firstIndex(where: \.isLetter)!))
    }
  )
}

public extension DependencyValues {
  var openAI: OpenAIClient {
    get { self[OpenAIClient.self] }
    set { self[OpenAIClient.self] = newValue }
  }
}

struct GPT3Request: Encodable {
  let model: String
  let prompt: String
  let max_tokens: Int
  let temperature: Double
  let top_p: Int
  let n: Int
  let stream: Bool
  let logprobs: Int?
  let stop: String
}

struct GPT3Response: Decodable {
  let id: String
  let object: String
  let created: Int
  let model: String
  let choices: [Choice]
  let usage: Usage
  
  struct Choice: Decodable {
    let text: String
    let index: Int
    let logprobs: Int?
    let finish_reason: String
  }
  
  struct Usage: Decodable {
    let prompt_tokens: Int
    let total_tokens: Int
  }
}

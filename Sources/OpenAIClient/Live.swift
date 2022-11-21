import Dependencies
import Foundation

extension OpenAIClient: DependencyKey {
  static public var liveValue = Self(
    generateDescription: {
      let prompt = "Lavishly describe a roasted turkey that just came out of the oven for thanksgiving. Don't mention the other thanksgiving food. Mention the gravy."
      let json = GPT3Request(model: "text-davinci-002", prompt: prompt, max_tokens: 6, temperature: 0)
      
      var request = URLRequest(url: URL(string: "https://api.openai.com/v1/completions")!)
      request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization": apiKey
      ]
      request.httpMethod = "POST"
      request.httpBody = try JSONEncoder().encode(json)
      
      let (data, t) = try await URLSession.shared.data(for: request)
      print(t)
      let choice = try JSONDecoder().decode(GPT3Response.self, from: data).choices[0]
      
      return choice.text
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
  let temperature: Int
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
    let completion_tokens: Int
    let total_tokens: Int
  }
}

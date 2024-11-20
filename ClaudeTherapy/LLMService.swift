import Foundation

class LLMService {
    // Fetch API key from Secrets.plist
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["AnthropicAPIKey"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return key
    }
    
    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-3-5-sonnet-20241022"
    private let systemPrompt = "You are a helpful and empathetic virtual therapist. Your goal is to provide emotional support and mental health guidance to users. Always respond in a thoughtful, compassionate, and nonjudgmental manner."
    
    func sendMessageToLLM(messages: [ChatMessage]) async throws -> String {
        // Validate URL
        guard let url = URL(string: baseURL) else {
            debugPrint("🔴 [LLMService] Invalid URL: \(baseURL)")
            throw LLMServiceError.invalidURL
        }
        
        // Configure request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // Convert messages to Claude's API format
        let formattedMessages = messages.map { message -> [String: String] in
            [
                "role": message.sender == "Bot" ? "assistant" : "user",
                "content": message.content
            ]
        }
        
        // Log messages being sent
        debugPrint("🟢 [LLMService] Sending Messages: \(formattedMessages)")
        
        // Prepare request body
        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": 2048,
            "messages": formattedMessages,
            "system": systemPrompt,
            "temperature": 0.7
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            debugPrint("🟢 [LLMService] Request Body: \(requestBody)")
        } catch {
            debugPrint("🔴 [LLMService] Error Serializing Request Body: \(error.localizedDescription)")
            throw LLMServiceError.parsingError(error)
        }
        
        // Perform network request using async/await
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("🟡 [LLMService] HTTP Response Status: \(httpResponse.statusCode)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                debugPrint("🔴 [LLMService] Invalid HTTP Response: \(response)")
                throw LLMServiceError.invalidResponse
            }
            
            // Log raw response
            if let rawResponse = String(data: data, encoding: .utf8) {
                debugPrint("🟢 [LLMService] Raw Response: \(rawResponse)")
            }
            
            // Parse and return response
            do {
                let decodedResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)
                guard let content = decodedResponse.content.first?.text else {
                    debugPrint("🔴 [LLMService] Missing or Invalid Content in Response")
                    throw LLMServiceError.invalidResponse
                }
                debugPrint("🟢 [LLMService] Decoded Response: \(decodedResponse)")
                return content
            } catch {
                debugPrint("🔴 [LLMService] JSON Parsing Error: \(error.localizedDescription)")
                throw LLMServiceError.parsingError(error)
            }
        } catch {
            debugPrint("🔴 [LLMService] Network Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
}

// Models for decoding the response
struct ClaudeResponse: Codable {
    let id: String
    let content: [MessageContent]
    let model: String
    let role: String
}

struct MessageContent: Codable {
    let text: String
    let type: String
}

// Custom error handling for LLMService
enum LLMServiceError: Error {
    case invalidURL
    case invalidResponse
    case parsingError(Error)
}

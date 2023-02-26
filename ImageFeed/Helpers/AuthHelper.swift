import Foundation

// MARK: - Protocol
protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    // MARK: - Properties
    let configuration: AuthConfiguration
    
    
    // MARK: - Methods
    func authRequest() -> URLRequest {
        let url = authUrl()
        return URLRequest(url: url)
    }
    
    func authUrl() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
    
    
    func code(from url: URL) -> String?{
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == Constants().authorize,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
    // MARK: - Init
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}

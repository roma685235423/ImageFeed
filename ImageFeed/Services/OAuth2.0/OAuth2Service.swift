import Foundation

final class OAuth2Service {
    
    //MARK: - Enumerations
    private enum NetworkError: Error {
        case codeError
    }
    
    
    //MARK: - Properties
    let unsplashAuthorizePostURLString = "https://unsplash.com/oauth/token"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    //MARK: - Methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void){
        
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = makeRequest(code: code)
        
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    completion(.success(jsonData.accessToken))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func makeRequest (code: String) -> URLRequest {
        
        var urlComponents = URLComponents(string: self.unsplashAuthorizePostURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.AccessKey),
            URLQueryItem(name: "client_secret", value: Constants.SecretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}


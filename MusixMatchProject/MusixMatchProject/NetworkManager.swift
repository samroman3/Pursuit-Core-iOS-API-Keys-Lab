import Foundation
class NetworkManager {
    
    // TODO: update this to cache
    private init() {}
    
    /// singleton
    static let shared = NetworkManager()
    
    //Performs GET requests for any URL
    //Parameters: URL as a string
    //Completion: Result with Data in success, AppError in failure
    
    func fetchData(urlString: String,  completionHandler: @escaping (Result<Data,AppError>) -> ()) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.badHTTPResponse))
                return
            }
            
            switch response.statusCode {
            case 404:
                completionHandler(.failure(.notFound))
            case 401,403:
                completionHandler(.failure(.unauthorized))
            case 200...299:
                completionHandler(.success(data))
            default:
                completionHandler(.failure(.other(errorDescription: "Wrong Status Code")))
            }
            }.resume()
    }
    
}

struct SearchAPIClient {
    private init() {}
    static let shared = SearchAPIClient()
    
    static func getResults(searchTerm: String , completionHandler: @escaping (Result<[TrackList],AppError>) -> () ) {
        let url = "http://api.musixmatch.com/ws/1.1/track.search?page_size=100&page=1&s_track_rating=desc&q_artist=\(searchTerm.lowercased())&apikey=50aa0a8f45e0ba5082bb0226cf8d5f6e"
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(TrackWrapper.self, from: data)
                    completionHandler(.success((decoded.message.body.track_list)))
                    
                } catch {
                    completionHandler(.failure(.badJSONError))
                    print(error)
             }
       }
    }
}

}


//
//  Lyrics.swift
//  MusixMatchProject
//
//  Created by Sam Roman on 9/10/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
struct Lyrics: Codable {
    let message: MessageWrapper
    
    static func loadLyrics(trackID: Int, completionHandler: @escaping (Result<Lyrics,AppError>) -> () ) {
        let searchID = String(trackID)
        let url = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=\(searchID)&apikey=50aa0a8f45e0ba5082bb0226cf8d5f6e"
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            case .success(let data):
                do {
                    let decode = try JSONDecoder().decode(Lyrics.self, from: data)
                    completionHandler(.success((decode)))
                } catch {
                    completionHandler(.failure(.badJSONError))
                }
            }
        }
    }
    
    
    
}

struct MessageWrapper: Codable {
    let body: BodyWrapper
}

struct BodyWrapper: Codable {
    let lyrics: LyricWrapper
}

struct LyricWrapper: Codable {
    let lyrics_body: String
}



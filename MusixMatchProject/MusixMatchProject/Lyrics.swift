//
//  Lyrics.swift
//  MusixMatchProject
//
//  Created by Sam Roman on 9/10/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation


struct TrackWrapper: Codable {
    let message: Message
    
    static func loadSongs(search: String?, completionHandler: @escaping (Result<[TrackList],AppError>) -> () ) {
        
        var url = ""
        if let searchWord = search?.lowercased() {
            url = "http://api.musixmatch.com/ws/1.1/track.search?page_size=100&page=1&s_track_rating=desc&q_artist=\(searchWord)&apikey=50aa0a8f45e0ba5082bb0226cf8d5f6e"
        }
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                print(error)
            case .success(let data):
                do {
                    let decode = try JSONDecoder().decode(TrackWrapper.self, from: data)
                    completionHandler(.success((decode.message.body.track_list)))
                } catch {
                    completionHandler(.failure(.badJSONError))
                }
            }
        }
    }
}

struct Message: Codable{
    let body: Body
}
struct Body: Codable {
    let track_list: [TrackList]
}
struct TrackList: Codable{
    let track: Track
}


struct Track: Codable {
    let track_id: Int
    let track_name: String
    let track_rating: Int
    let has_lyrics: Int
    let album_id: Int
    let album_name: String
    let artist_id: Int
    let artist_name: String
    
    //TODO: make computed property to get lyrics
    var url: String? {
        return String(album_id)
    }
    
}

/*struct Music: Codable{
 let message: Message
 static func getMusic(userInput: String?,completionHandler: @escaping (Result<[TrackList],AppError>) -> () ) {
 var url = "http://api.musixmatch.com/ws/1.1/track.search?q_artist=kanye&page_size=100&page=1&s_track_rating=desc&apikey=3445509192b50cd7ccfe4df777f38cb2"
 if let word = userInput{
 let newString = word.replacingOccurrences(of: " ", with: "-")
 url = "http://api.musixmatch.com/ws/1.1/track.search?q_artist=\(newString)&page_size=100&page=1&s_track_rating=desc&apikey=3445509192b50cd7ccfe4df777f38cb2"
 
 }
 NetWorkManager.shared.fetchData(urlString: url) { (result) in
 print(url)
 switch result {
 case .failure(let error):
 completionHandler(.failure(error))
 case .success(let data):
 do {
 let decodedShow = try JSONDecoder().decode(Music.self, from: data)
 completionHandler(.success(decodedShow.message.body.track_list))
 } catch {
 completionHandler(.failure(.badJSONError))
 print(error)
 }
 }
 }
 }
 }
 struct Message: Codable{
 let body: Body
 }
 struct Body: Codable{
 let track_list: [TrackList]
 }
 struct TrackList: Codable{
 let track: Track
 }
 struct Track: Codable{
 let track_id: Int
 let track_name: String
 let artist_name: String
 }*/

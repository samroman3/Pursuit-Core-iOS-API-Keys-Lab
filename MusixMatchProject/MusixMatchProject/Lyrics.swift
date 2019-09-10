//
//  Lyrics.swift
//  MusixMatchProject
//
//  Created by Sam Roman on 9/10/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation


struct TrackWrapper: Codable {
    let message: Body
    
    static func loadShows(search: String?, completionHandler: @escaping (Result<[Track],AppError>) -> () ) {
        
        var url = ""
        if let searchWord = search?.lowercased() {
            url = "http://api.musixmatch.com/ws/1.1/track.search?apikey=50aa0a8f45e0ba5082bb0226cf8d5f6e&q_artist=\(searchWord)"
        }
        NetworkManager.shared.fetchData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let shows = try JSONDecoder().decode([Track].self, from: data)
                    completionHandler(.success(shows))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}


struct Body: Codable {
    let tracklist: [Track]
}


struct Track: Codable {
    let track_id: String
    let track_name: String
    let track_rating: Int
    let has_lyrics: Int
    let album_id: Int
    let album_name: String
    let artist_id: Int
    let artist_name: String
    
    //TODO: make computed property to get lyrics
    var url: String {
        return String(album_id)
    }
    
}

/*[
 {
 "track": {
 "track_id": 85078352,
 "track_name": "Sorry (Acoustic)",
 "track_name_translation_list": [],
 "track_rating": 5,
 "commontrack_id": 47918723,
 "instrumental": 1,
 "explicit": 0,
 "has_lyrics": 0,
 "has_subtitles": 0,
 "has_richsync": 0,
 "num_favourite": 5,
 "album_id": 20950721,
 "album_name": "Sorry (Acoustic)",
 "artist_id": 28719754,
 "artist_name": "J. Cordova",
 "track_share_url": "https://www.musixmatch.com/lyrics/J-Cordova/Sorry-Acoustic?utm_source=application&utm_campaign=api&utm_medium=Pursuit%3A1409618580260",
 "track_edit_url": "https://www.musixmatch.com/lyrics/J-Cordova/Sorry-Acoustic/edit?utm_source=application&utm_campaign=api&utm_medium=Pursuit%3A1409618580260",*/

//
//  LyricsDetailViewController.swift
//  MusixMatchProject
//
//  Created by Sam Roman on 9/10/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class LyricsDetailViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songLabel: UILabel!
    
    @IBOutlet weak var lyricTextField: UITextView!
    
    
    var endPoint: Track? {
        didSet {
            DispatchQueue.main.async {
            self.artistLabel.text = self.endPoint?.artist_name ?? ""
            self.songLabel.text = self.endPoint?.track_name ?? ""
    }
        }
    }
    var lyrics: LyricWrapper? {
        didSet {
        if lyrics?.lyrics_body != ""  {
        lyricTextField.text = lyrics?.lyrics_body
        } else {
            lyricTextField.text = "..Lyrics Unavailable.."
            }
    }
    }
    
    func loadData(idnum: Int?){
        if let id = idnum{
            Lyrics.loadLyrics(trackID: id){ (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    DispatchQueue.main.async{
                        return self.lyrics = data.self
                    }
                }
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        loadData(idnum: endPoint?.track_id)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

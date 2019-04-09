//
//  ViewController.swift
//  Audio Capture and Playback
//
//  Created by Brock Gibson on 4/8/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import AVKit

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    let audioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error! Could not play: Decoding failure!")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error! Could not record: Encoding failure!")
    }

}


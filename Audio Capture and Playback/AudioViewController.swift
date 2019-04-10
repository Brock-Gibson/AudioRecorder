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
    
    let playImage = UIImage(named: "play")
    let stopImage = UIImage(named: "stop")
    let pauseImage = UIImage(named: "pause")
    let recordImage = UIImage(named: "record")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioSession.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                //permission granted
                
                let fileManager = FileManager.default
                let documentDirectoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentDirectoryURL = documentDirectoryPaths[0]
                let audioFileName = "audio.caf"
                let audioFileURL = documentDirectoryURL.appendingPathComponent(audioFileName)
                let recordingSettings =
                    [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                     AVEncoderBitRateKey: 16,
                     AVNumberOfChannelsKey: 2,
                     AVSampleRateKey: 44100.0] as [String : Any]
                
                do {
                    try self.audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                } catch let error {
                    print("audioSession error: \(error)")
                }
                
                do {
                    try self.audioRecorder = AVAudioRecorder(url: audioFileURL, settings: recordingSettings)
                    self.audioRecorder?.prepareToRecord()
                } catch let error {
                    print("audioSession error: \(error)")
                }
                
                self.recordButton.isEnabled = true
                self.playButton.isEnabled = false
            } else {
                // permission denied
                self.recordButton.isEnabled = false
                self.playButton.isEnabled = false
            }
        }
    }
    
    @IBAction func recordPressed(_ sender: Any) {
        if(audioRecorder?.isRecording == false) {
            recordButton.image = stopImage
            playButton.isEnabled = false
            audioRecorder?.record()
        } else {
            recordButton.image = recordImage
            playButton.isEnabled = true
            audioRecorder?.stop()
        }
    }
    
    @IBAction func playPressed(_ sender: Any) {
        if (audioRecorder?.isRecording == false) {
            playButton.image = stopImage
            recordButton.isEnabled = false
            
            if audioPlayer?.isPlaying == true {
                audioPlayer?.stop()
                playButton.image = playImage
                recordButton.isEnabled = true
                return
            }
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            }
            catch let error {
                print(error)
            }
        } else {
            playButton.image = playImage
            recordButton.isEnabled = true
            audioPlayer?.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.image = playImage
        playButton.isEnabled = true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        alertNotifyUser(message: "Audio Record Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        alertNotifyUser(message: "Audio Record Encode Error")
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            (alertAction) -> Void in
            print("OK selected")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}


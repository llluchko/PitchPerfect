//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Latchezar Mladenov on 10/12/15.
//  Copyright (c) 2015 Latchezar Mladenov. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
 
    @IBOutlet weak var recordInProgress: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    func setControls(_ stopHidden: Bool, pauseHidden: Bool, resumeHidden: Bool, recordEnabled: Bool, recordText: String){
        stopButton.isHidden = stopHidden
        pauseButton.isHidden = pauseHidden
        resumeButton.isHidden = resumeHidden
        recordButton.isEnabled = recordEnabled
        recordInProgress.text = recordText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setControls(true, pauseHidden: true, resumeHidden: true, recordEnabled: true, recordText: "Record!")
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        setControls(false, pauseHidden: false, resumeHidden: true, recordEnabled: false, recordText: "Recording!")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        //Set up audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch {
            print("could not set output to speaker")
        }
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        //Initialize and prepare the recorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio.init(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Recording was not successful"
            alert.addButton(withTitle: "Ok")
            alert.show()
            setControls(true, pauseHidden: true, resumeHidden: true, recordEnabled: true, recordText: "Record!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destination as!PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(_ sender: UIButton) {
        audioRecorder.pause()
        setControls(false, pauseHidden: true, resumeHidden: false, recordEnabled: false, recordText: "Paused!")
    }
    
    @IBAction func resumeRecording(_ sender: UIButton) {
        audioRecorder.record()
        setControls(false, pauseHidden: false, resumeHidden: true, recordEnabled: false, recordText: "Recording!")
    }
}

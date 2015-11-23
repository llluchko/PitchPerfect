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
    
    func setControls(stopHidden: Bool, pauseHidden: Bool, resumeHidden: Bool, recordEnabled: Bool, recordText: String){
        stopButton.hidden = stopHidden
        pauseButton.hidden = pauseHidden
        resumeButton.hidden = resumeHidden
        recordButton.enabled = recordEnabled
        recordInProgress.text = recordText
    }
    
    override func viewWillAppear(animated: Bool) {
        setControls(true, pauseHidden: true, resumeHidden: true, recordEnabled: true, recordText: "Record!")
    }

    @IBAction func recordAudio(sender: UIButton) {
        setControls(false, pauseHidden: false, resumeHidden: true, recordEnabled: false, recordText: "Recording!")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //Set up audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch {
            print("could not set output to speaker")
        }
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        //Initialize and prepare the recorder
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio.init(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Recording was not successful"
            alert.addButtonWithTitle("Ok")
            alert.show()
            setControls(true, pauseHidden: true, resumeHidden: true, recordEnabled: true, recordText: "Record!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as!PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        setControls(false, pauseHidden: true, resumeHidden: false, recordEnabled: false, recordText: "Paused!")
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        setControls(false, pauseHidden: false, resumeHidden: true, recordEnabled: false, recordText: "Recording!")
    }
}






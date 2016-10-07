//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Latchezar Mladenov on 10/18/15.
//  Copyright © 2015 Latchezar Mladenov. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine();
        
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        stopAudio()
    }
    
    @IBAction func playSlowAudio(_ sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(_ sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
  
    @IBAction func playReverbAudio(_ sender: UIButton) {
        playAudioWithVariableReverb(50)
    }
    
    func stopAudio(){
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
    func playAudioWithVariableRate(_ rate: Float){
        stopAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(_ pitch: Float) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableReverb(_ reverb: Float){
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = reverb
        audioEngine.attach(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
}

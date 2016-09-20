//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Timothy Myers on 9/16/16.
//  Copyright © 2016 Denver Coders. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButon: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
		
		configureRecordingButton(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
		let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
		audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
		configureRecordingButton(isRecording: false)
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
    }

	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		print("finished recording")
		if(flag){
			self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
		}else{
			print("Saving failed")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "stopRecording"){
			let playSoundsVC = segue.destination as! PlaySoundsViewController
			let recordedAudioURL = sender as! NSURL
			playSoundsVC.recordedAudioURL = recordedAudioURL
		}
	}
	
	func configureRecordingButton(isRecording: Bool){
		recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
		recordButon.isEnabled = isRecording ? false: true
		stopRecordingButton.isEnabled = isRecording ? true : false
	}
}


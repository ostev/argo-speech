//
//  ViewController.swift
//  DashTen
//
//  Created by Oscar Stevens on 18/12/20.
//

import UIKit
import Speech

class ViewController: UIViewController {
    private let recognizer = SFSpeechRecognizer()!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    func startRecording() throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        
        if #available(iOS 13, *) {
            recognitionRequest!.requiresOnDeviceRecognition = true
        }
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                print("Text recognised: \"\(result.bestTranscription.formattedString)\"")
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
          }
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .notDetermined:print ("Not determined")
            case .restricted: print("Restricted")
            case .denied: print("Denied")
            case .authorized: print("Authorised")
            default: print("Unknown case")
            }
        }
        do {
            try startRecording()
            print("Started recording...")
        } catch {
            print("Unexpected error: \(error)")
        }
    }


}


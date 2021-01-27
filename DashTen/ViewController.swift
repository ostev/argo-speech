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
    private var isRecording = false
    
    private var model = Model()
    
    @IBAction func onButtonPress(_ sender: UIButton) {
        isRecording = !isRecording
        if isRecording {
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
                print("Started listening...")
                button.setTitle("S T O P   L I S T E N I N G", for: .normal)
            } catch {
                print("Unexpected error: \(error)")
            }
        } else {
            stopRecording()
            button.setTitle("S T A R T  L I S T E N I N G", for: .normal)
        }
    }

    @IBOutlet var button: UIButton!
    
    private func startRecording() throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        
        recognitionRequest!.requiresOnDeviceRecognition = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false
            
            
            if let result = result {
                isFinal = result.isFinal
                let text = result.bestTranscription.formattedString
                print("Text recognised: \"\(text)\"")
                self.model.transcript = text
            }
            
            if error != nil || isFinal {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
          }
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    private func stopRecording() {
        let inputNode = audioEngine.inputNode
        
        self.audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }


}


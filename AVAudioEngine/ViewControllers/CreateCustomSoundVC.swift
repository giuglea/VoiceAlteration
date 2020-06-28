//
//  CreateCustomSound.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 25/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit
import AVFoundation

class CreeateCustomSoundVC: UIViewController{
    
    var echoTypes = ["Drums Bit Brush","Drums Buffer Beats"]
    var reverbTypes = ["Cathedral"]
    var test = [AVAudioUnitReverbPreset]()
    var database = Database()
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    // func playCustomSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, echoType: AVAudioUnitDistortionPreset = .multiEcho1, reverb: Bool = false, reverbType: AVAudioUnitReverbPreset = .largeChamber, reverbDryMix: Float = 50)
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var reverbDryMixLabel: UILabel!
    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var reverbSlider: UISlider!
    
    @IBOutlet weak var rateStepper: UIStepper!
    @IBOutlet weak var pitchStepper: UIStepper!
    @IBOutlet weak var reverbStepper: UIStepper!
    
    @IBOutlet weak var echoTypePicker: UIPickerView!
    @IBOutlet weak var reverbTypePicker: UIPickerView!
    
    @IBOutlet weak var echoPicker: UIPickerView!
    @IBOutlet weak var reverbPicker: UIPickerView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    struct  AlertSound{
        static let customSoundSaved = "The Custom Sound was Saved"
        static let customSoundAlreadySaved = "The Same Custom Sound was already saved and added to your library"
        static let dismissAlert = "Dismiss"
    }
    
    
    var audioObject = CustomSoundModel(rate: 1, pitch: 0, echo: false, echoType: .drumsBitBrush, reverb: false, reverbType: .cathedral, reverbDryMix: 0)
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupAudio()
       
    }
    
    
    func configureUI(){
        setUpSliders()
        setUpSteppers()
        setUpLabels()
        setUpPickers()
        stopButton.isHidden = true
        
    }
    
    
    @IBAction func echoStateSwitch(_ sender: UISwitch) {
        if sender.isOn == true{
            echoTypePicker.isUserInteractionEnabled = true
            
        }else{
            echoTypePicker.isUserInteractionEnabled = false
        }
        audioObject.echo = sender.isOn
    }
    
    @IBAction func reverbStateSwitch(_ sender: UISwitch) {
        if sender.isOn == true{
            reverbTypePicker.isUserInteractionEnabled = true
        }else{
            reverbTypePicker.isUserInteractionEnabled = false
        }
        audioObject.reverb = sender.isOn
    }
    
    func setUpSliders(){
        rateSlider.minimumValue = 1
        rateSlider.maximumValue = 10
        
        pitchSlider.minimumValue = 0
        pitchSlider.value = 1000
        pitchSlider.maximumValue = 2000
        
        reverbSlider.minimumValue = 0
        reverbSlider.maximumValue = 100
    }
    
    func setUpSteppers(){
        rateStepper.minimumValue = 1
        rateStepper.maximumValue = 10
        
        pitchStepper.minimumValue = 0
        pitchStepper.value = 1000
        pitchStepper.maximumValue = 2000
        
        reverbSlider.minimumValue = 0
        reverbSlider.maximumValue = 100
    }
    
    func setUpLabels(){
        rateLabel.text! = String(Int(rateSlider.value))
        pitchLabel.text! = String(Int(pitchSlider.value)-1000)
        reverbDryMixLabel.text! = String(Int(reverbSlider.value))
    }
    
    func  setUpPickers(){
        echoPicker.delegate = self
        echoPicker.dataSource = self
        reverbPicker.delegate = self
        reverbPicker.dataSource = self
        
        echoTypePicker.isUserInteractionEnabled = false
        reverbTypePicker.isUserInteractionEnabled = false
    }
    
    //TODO: Create hide animation here
    
    
    
    
    @IBAction func rateSlider(_ sender: UISlider) {
        var rateValue = Int(sender.value)
        rateLabel.text! = String(rateValue)
        rateStepper.value = Double(rateValue)
        audioObject.rate = sender.value
    }
    
    @IBAction func pitchSlider(_ sender: UISlider) {
        var pitchValue = Int(sender.value)
        pitchLabel.text! = String(pitchValue-1000)
        pitchStepper.value = Double(pitchValue)
        audioObject.pitch = sender.value-1000
        
    }
    
    
    @IBAction func reverbSlider(_ sender: UISlider) {
        var reverbValue = Int(sender.value)
        reverbDryMixLabel.text! = String(reverbValue)
        reverbStepper.value  = Double(reverbValue)
        audioObject.reverbDryMix = sender.value
    }
    
    @IBAction func rateStepper(_ sender: UIStepper) {
        var rateValue = Int(sender.value)
        rateLabel.text! = String(rateValue)
        rateSlider.value = Float(rateValue)
        audioObject.rate = Float(sender.value)
    }
    
    
    @IBAction func pitchStepper(_ sender: UIStepper) {
        var pitchValue = Int(sender.value)
        pitchLabel.text! = String(pitchValue-1000)
        pitchSlider.value = Float(pitchValue)
        audioObject.pitch = Float(sender.value)-1000
    }
    
    @IBAction func reverbStepper(_ sender: UIStepper) {
        var reverbValue = Int(sender.value)
        reverbDryMixLabel.text! = String(reverbValue)
        reverbSlider.value = Float(reverbValue)
        audioObject.reverbDryMix = Float(sender.value)
    }
    
    
    
    @IBAction func playAndTestSound(_ sender: Any) {
        playCustomSound(customSound: audioObject)
        playButton.isEnabled = false
        stopButton.isHidden = false
        
        
    }
    
    
    @IBAction func stopAudio(_ sender: Any) {
        stopAudio()
        playButton.isEnabled = true
        stopButton.isHidden  = true
    }
    
    
    @IBAction func saveCustomSound(_ sender: Any) {
        audioObject.printModel()
        
        //TODO: Dif custom sound before adds with database
        
      
//        if audioObject == previousAudioObject{
//            let alert = UIAlertController( title: AlertSound.customSoundAlreadySaved, message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: AlertSound.dismissAlert, style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//        }
//        else{
//            let alert = UIAlertController( title: AlertSound.customSoundSaved, message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: AlertSound.dismissAlert, style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            previousAudioObject = audioObject
//
//        }
        
        database.insertCustomSound(customSound: audioObject)//insert with last index
      
        
    }
    
    
    func playCustomSound(customSound: CustomSoundModel){
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchNode = AVAudioUnitTimePitch()
        if let pitch = customSound.pitch{
            changePitchNode.pitch = pitch
        }
        
        if let rate = customSound.rate{
            changePitchNode.rate = rate
        }
        
        audioEngine.attach(changePitchNode)
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(customSound.echoType)
        audioEngine.attach(echoNode)
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(customSound.reverbType)
        reverbNode.wetDryMix = customSound.reverbDryMix
        audioEngine.attach(reverbNode)
        
        if customSound.echo == true && customSound.reverb == true{
            connectAudioNodes(audioPlayerNode, changePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        }else if customSound.echo == true && customSound.reverb == false{
            connectAudioNodes(audioPlayerNode, changePitchNode, echoNode, audioEngine.outputNode)
        }else if customSound.echo == false && customSound.reverb == true{
            connectAudioNodes(audioPlayerNode, changePitchNode, reverbNode, audioEngine.outputNode)
        }else{
            connectAudioNodes(audioPlayerNode, changePitchNode, audioEngine.outputNode)
        }
        
        audioPlayerNode.stop()
        
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            var delayInSeconds: Double = 0
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime,let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime){
                if let rate = customSound.rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(self.stopAudio(_:)), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
            
        }
        
        do {
            try audioEngine.start()
        } catch {
           
            return
        }
       
        audioPlayerNode.play()
        
        
        
        
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
           for x in 0..<nodes.count-1 {
               audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
           }
       }
    
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        //configureUI(.notPlaying)
                        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    func setupAudio() {
         // initialize (recording) audio file
         do {
             audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
         } catch {
             //showAlert(Alerts.AudioFileError, message: String(describing: error))
         }
     }
    
    
    

    
    
    
}


extension CreeateCustomSoundVC: UIPickerViewDelegate, UIPickerViewDataSource{
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          1
    }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return echoTypes.count
        }
        if pickerView.tag == 1{
            return reverbTypes.count
        }
        return 0
      }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return echoTypes[row]
        }
       
        return reverbTypes[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            audioObject.echoType = AVAudioUnitDistortionPreset(rawValue: row) ?? AVAudioUnitDistortionPreset.drumsBitBrush
        }
        if pickerView.tag == 1{
            audioObject.reverbType = AVAudioUnitReverbPreset(rawValue: row) ?? AVAudioUnitReverbPreset.cathedral
        }
    }
    
    
}






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
    var echoTypes = ["drumsBitBrush","drumsBufferBeats"]
    var reverbTypes = ["cathedral"]
    
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
    
    var audioObject = CustomSoundModel(rate: nil, pitch: nil, echo: false, echoType: .drumsBitBrush, reverb: false, reverbType: .cathedral, reverbDryMix: 50)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
        
       
    }
    
    
    func configureUI(){
        setUpSliders()
        setUpSteppers()
        setUpLabels()
        setUpPickers()
    
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
        rateSlider.minimumValue = 0
        rateSlider.maximumValue = 10
        
        pitchSlider.minimumValue = 0
        pitchSlider.maximumValue = 2000
        
        reverbSlider.minimumValue = 0
        reverbSlider.maximumValue = 100
        
        
    }
    
    func setUpSteppers(){
        rateStepper.minimumValue = 0
        rateStepper.maximumValue = 10
        
        pitchStepper.minimumValue = 0
        pitchStepper.maximumValue = 2000
        
        reverbSlider.minimumValue = 0
        reverbSlider.maximumValue = 100
    }
    
    func setUpLabels(){
        rateLabel.text! = String(Int(rateSlider.value))
        pitchLabel.text! = String(Int(pitchSlider.value))
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
    
    
    
    
    @IBAction func rateSlider(_ sender: UISlider) {
        var rateValue = Int(sender.value)
        rateLabel.text! = String(rateValue)
        rateStepper.value = Double(rateValue)
    }
    
    @IBAction func pitchSlider(_ sender: UISlider) {
        var pitchValue = Int(sender.value)
        pitchLabel.text! = String(pitchValue)
        pitchStepper.value = Double(pitchValue)
        
    }
    
    @IBAction func reverbSlider(_ sender: UISlider) {
        var reverbValue = Int(sender.value)
        reverbDryMixLabel.text! = String(reverbValue)
        reverbStepper.value  = Double(reverbValue)
    }
    
    
    
    
    @IBAction func rateStepper(_ sender: UIStepper) {
        var rateValue = Int(sender.value)
        rateLabel.text! = String(rateValue)
        rateSlider.value = Float(rateValue)
        
    }
    
    
    @IBAction func pitchStepper(_ sender: UIStepper) {
        var pitchValue = Int(sender.value)
        pitchLabel.text! = String(pitchValue)
        pitchSlider.value = Float(pitchValue)
    }
    
    
    @IBAction func reverbStepper(_ sender: UIStepper) {
        var reverbValue = Int(sender.value)
        reverbDryMixLabel.text! = String(reverbValue)
        reverbSlider.value = Float(reverbValue)
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






//
//  CreateCustomSound.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 25/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

class CreeateCustomSoundVC: UIViewController{
    // func playCustomSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, echoType: AVAudioUnitDistortionPreset = .multiEcho1, reverb: Bool = false, reverbType: AVAudioUnitReverbPreset = .largeChamber, reverbDryMix: Float = 50)
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var reverbDryMixLabel: UILabel!
    
    @IBOutlet weak var echoTypePicker: UIPickerView!
    @IBOutlet weak var reverbTypePicker: UIPickerView!
    
    var audioObject = CustomSoundModel(rate: nil, pitch: nil, echo: false, echoType: .drumsBitBrush, reverb: false, reverbType: .cathedral, reverbDryMix: 50)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        echoTypePicker.isUserInteractionEnabled = false
        reverbTypePicker.isUserInteractionEnabled = false
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
    
    
    
    
    
    
    
    
    
}

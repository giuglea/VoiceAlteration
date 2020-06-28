//
//  CustomSoundCell.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 17/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//


import UIKit


class CustomSoundCell: UICollectionViewCell {
    
    
    @IBOutlet weak var customSoundImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setHideMode(mode: true)
        
    }
    
    
    @IBAction func deleteThisCustomSound(_ sender: Any) {
        
    }
    
    @IBAction func updateThisCustomSound(_ sender: Any) {
        
    }
    
    //TODO: Change Name of func
    func setHideMode(mode: Bool){
        deleteButton.isHidden = mode
        updateButton.isHidden = mode
    }
    
}

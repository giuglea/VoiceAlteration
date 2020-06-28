//
//  Database.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 08/06/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import Foundation
import AVFoundation
import SQLite

class Database{
    
    var db: OpaquePointer? = nil
    var fileURL: Any? = nil

    init(){
        self.openDatabase()
        self.createCustomSoundTable()
    }
    init(created: Bool){
        if created == false{
            self.createDatabase()
        }
    }

    
    func createDatabase(){
        do{
            let manager = FileManager.default
            let documentURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("myDB.db")
            var rc = sqlite3_open(documentURL.path, &db)
            if rc == SQLITE_CANTOPEN{
                let bundleULR = Bundle.main.url(forResource: "myDB", withExtension: "db")!
                try manager.copyItem(at:bundleULR,to:documentURL)
            }
            if rc != SQLITE_OK{
                print("Error : \(rc)  ")
            }
        }
        catch{
            print(error)
        }
    }
    
    
    
    func openDatabase(){
          do{
              let manager = FileManager.default
              let documentURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("myDB.db")
                  
              var rc = sqlite3_open_v2(documentURL.path, &db, SQLITE_OPEN_READWRITE, nil)
              if rc == SQLITE_CANTOPEN{
                  let bundleULR = Bundle.main.url(forResource: "myDB", withExtension: "db")!
                  try manager.copyItem(at:bundleULR,to:documentURL)
                  }
                  if rc != SQLITE_OK{
                      print("Error : \(rc)  ")
                  }
          }
          catch{
              print(error)
          }
      }
    
    
    
    
    func createCustomSoundTable(){
     
        var createTableString = "CREATE TABLE  CustomSound (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Rate FLOAT, Pitch FLOAT, Echo INT, EchoType INT, Reverb INT, ReverbType INT, DryMix FLOAT);"
        var createTableStatement: OpaquePointer? = nil
           
           if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil)==SQLITE_OK{
               if sqlite3_step(createTableStatement)==SQLITE_DONE{
                   print("CustomSound Table created")
                   
               }
               else {
                   print("CustomSound Table could not be created")
               }
           }
           else{
               print("CREATE TABLE statement could not be prepared")
           }
           sqlite3_finalize(createTableStatement)
       }
    
    
    
    func insertCustomSound(customSound: CustomSoundModel){
        
        let insertStatementString = "INSERT INTO CustomSound (Id, Rate, Pitch, Echo, EchoType, Reverb, ReverbType, DryMix) VALUES (?, '\(customSound.rate!)', '\(customSound.pitch!)', '\(customSound.echo ? 1:0)', '\(customSound.echoType.hashValue)', '\(customSound.reverb ? 1:0)', '\(customSound.reverbType.hashValue)', '\(customSound.reverbDryMix)');"
        var insertStatement:OpaquePointer?=nil
        
           if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
           
               if sqlite3_step(insertStatement) == SQLITE_DONE {
                   print("Successfully inserted row.")
           
               } else {
                   print("Could not insert row.")
               }
            
           } else  {
               print("INSERT statement could not be prepared.")
           }
           sqlite3_finalize(insertStatement)
  
    }
    
    
    func getCustomSounds()->[CustomSoundModel]{
        var queryStatement: OpaquePointer? = nil
        let queryStatementString = "SELECT * FROM CustomSound;"
        
        var customSoundArray = [CustomSoundModel]()
        
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {

             while (sqlite3_step(queryStatement) == SQLITE_ROW) {
           
                let rate  = Float(sqlite3_column_double(queryStatement, 1))
                let pitch = Float(sqlite3_column_double(queryStatement, 2))
                
                let echo = sqlite3_column_int(queryStatement, 3).toBool()
                let echoType = Int(sqlite3_column_int(queryStatement, 4))
                let echoTypeConversion = AVAudioUnitDistortionPreset(rawValue: echoType) ?? AVAudioUnitDistortionPreset.drumsBitBrush
                
                let reverb = sqlite3_column_int(queryStatement, 5).toBool()
                let reverbType = Int(sqlite3_column_int(queryStatement, 6))
                let reverbTypeConversion = AVAudioUnitReverbPreset(rawValue: reverbType) ?? AVAudioUnitReverbPreset.cathedral
                let dryMix = Float(sqlite3_column_int(queryStatement, 7))
                
                let customSound = CustomSoundModel(rate: rate, pitch: pitch, echo: echo, echoType: echoTypeConversion, reverb: reverb, reverbType: reverbTypeConversion, reverbDryMix: dryMix)
                customSound.printModel()
                
                customSoundArray.append(customSound)
                
                
             }

           } else {
             print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
        
        return customSoundArray
        
        
    }
    
    
    func deleteCustomSoundTable(){
        let deleteStatementString = "DROP TABLE CustomSound;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,deleteStatementString, -1, &deleteStatement, nil)==SQLITE_OK{
            if sqlite3_step(deleteStatement)==SQLITE_DONE{
                print("Table Deleted")
            }
            else{
                print("Table could not be deleted")
            }
        }
        else{
            print("Delete statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        
    }
    
    
       func deleteCustomSound(customSound: CustomSoundModel)->Bool{
           //(Id, Rate, Pitch, Echo, EchoType, Reverb, ReverbType, DryMix)
        let deleteStatementString = "DELETE FROM  CustomSound WHERE Rate = '\(customSound.rate)' AND Pitch = '\(customSound.pitch)' AND Echo = '\(customSound.echo ? 1:0)' AND EchoType = '\(customSound.echoType.hashValue)' AND Reverb = '\(customSound.reverb ? 1:0)' AND ReverbType = '\(customSound.reverbType.hashValue)' AND DryMix = '\(customSound.reverbDryMix)';"
           
           var deleteRowStatement: OpaquePointer? = nil
           
           if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteRowStatement, nil)==SQLITE_OK{
               if sqlite3_step(deleteRowStatement)==SQLITE_DONE{
                    print("CustomSound Row deleted")
                    sqlite3_finalize(deleteRowStatement)
                    return true
                   
               }
               else {
                   print("Row could not be deleted")
               }
           }
           else{
               print("Delete Row statement could not be prepared")
           }
           sqlite3_finalize(deleteRowStatement)
           
           return false
       }
    
    
}


extension Int32{
    
    func toBool()->Bool{
        if self == 0{
            return false
        }
        else{
            return true
        }
        
    }
    
}

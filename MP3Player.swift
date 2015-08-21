//
//  MP3Player.swift
//  MP3Player
//
//  Created by James Tyner on 7/17/15.
//  Copyright (c) 2015 James Tyner. All rights reserved.
//

import UIKit
import AVFoundation

class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer?
    var currentTrackIndex = 0
    var tracks:[String] = [String]()
    
    override init(){
        tracks = FileReader.readFiles()
        super.init()
        queueTrack();
        
    }
    
    func queueTrack(){
        
        if(player != nil){
            player = nil
        }
        
        var error:NSError?
        let url = NSURL.fileURLWithPath(tracks[currentTrackIndex] as String)
        player = AVAudioPlayer(contentsOfURL: url, error: &error)
        
            if let hasError = error {
            //SHOW ALERT OR SOMETHING
            } else {
                player?.delegate = self
                player?.prepareToPlay()
            }
        NSNotificationCenter.defaultCenter().postNotificationName("SetTrackNameText", object: nil)
      }
    
    func play() {
        if player?.playing == false {
             player?.play()
	}
        
    }
    
    func stop(){
        if player?.playing == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    
    func pause(){
        if player?.playing == true{
            player?.pause()
        }
    }
    
    func nextSong(songFinishedPlaying:Bool){
        var playerWasPlaying = false
        if player?.playing == true {
            player?.stop()
            playerWasPlaying = true
        }

        currentTrackIndex++
        if currentTrackIndex >= tracks.count {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player?.play()
        }
        
    }
    
    func previousSong(){
        var playerWasPlaying = false
        if player?.playing == true {
            player?.stop()
            playerWasPlaying = true
        }
        currentTrackIndex--
        if currentTrackIndex < 0 {
            currentTrackIndex = tracks.count - 1
        }
        
        queueTrack()
        if playerWasPlaying {
            player?.play()
        }
    }
    
    func getCurrentTrackName() -> String {
        let trackName = tracks[currentTrackIndex].lastPathComponent.stringByDeletingPathExtension
        return trackName
    }

    
    func getCurrentTimeAsString() -> String {
        var seconds = 0
        var minutes = 0
        if let time = player?.currentTime {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        return String(format: "%0.2d:%0.2d",minutes,seconds)
   }
    
    func getProgress()->Float{
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = player?.currentTime, duration = player?.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        
        return Float(theCurrentTime / theCurrentDuration)
    }
    
    func setVolume(volume:Float){
        player?.volume = volume
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
        successfully flag: Bool){
            if flag == true {
                nextSong(true)
           }
    }
}


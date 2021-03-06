//
//  AlarmViewController.swift
//  SquareHackNight0
//
//  Created by Scotty Shaw on 7/19/16.
//  Copyright © 2016 ___sks6___. All rights reserved.
//

import UIKit
import AVFoundation

class AlarmViewController: UIViewController {
    
    var dosEquisThemeSong: AVAudioPlayer?
    var timer = NSTimer()
    var startingTime = NSTimeInterval()
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var currentTimeDisplayLabel: UILabel!
    
    @IBOutlet weak var alarmTimeDisplayLabel: UILabel!
    
    var alarmHour: Int = 21
    var alarmMinute: Int = 03
    var alarmSecond: Int = 05
    
    @IBAction func stopAlarm(sender: AnyObject) {
        dosEquisThemeSong?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dosEquisThemeSong = self.setupAudioPlayerWithFile("DosEquisThemeSong", type:"mp3") {
            self.dosEquisThemeSong = dosEquisThemeSong
        }
        
        let functionSelector: Selector = #selector(AlarmViewController.updateTime)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: functionSelector, userInfo: nil, repeats: true)
        startingTime = NSDate.timeIntervalSinceReferenceDate()
        
        let strAlarmHour = String(format: "%02d", alarmHour)
        let strAlarmMinute = String(format: "%02d", alarmMinute)
        let strAlarmSecond = String(format: "%02d", alarmSecond)
        
        alarmTimeDisplayLabel.text = "\(strAlarmHour):\(strAlarmMinute):\(strAlarmSecond)"
    }
    
    func setupAudioPlayerWithFile(file: NSString, type: NSString) -> AVAudioPlayer?  {
        
        // 1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        // 2
        var audioPlayer: AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        }
        catch {
            print("Player not available")
        }
        
        // 4
        return audioPlayer
    }
    
    func updateTime () {
        let date = timer.fireDate
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Second, .Minute, .Hour], fromDate: date)
        
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        // add the leading zero for minutes, seconds and milliseconds and store them as string constants
        let strHour = String(format: "%02d", hour)
        let strMinute = String(format: "%02d", minute)
        let strSecond = String(format: "%02d", second)
        
        // concatenate minutes, seconds and milliseconds and assign them to the UILabel
        currentTimeDisplayLabel.text = "\(strHour):\(strMinute):\(strSecond)"
        
        // song loops repeatedly
        if (alarmHour == hour && alarmMinute == minute && alarmSecond == second) {
            dosEquisThemeSong?.volume = 1
            dosEquisThemeSong?.play()
        }
        
        if (alarmHour == hour && alarmMinute == minute && alarmSecond == (second - 10)) {
            if dosEquisThemeSong!.playing {
                statusLabel.text = "YOU PAID UP"
            }
            else {
                statusLabel.text = "YOU WOKE UP"
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
                                     successfully flag: Bool) {
        if flag {
            print("end")
        }
    }
}

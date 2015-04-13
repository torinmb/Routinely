//
//  CardViewController.swift
//  Routinely
//
//  Created by Torin Blankensmith on 4/8/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.
//

import UIKit
import Spring

class CardViewController: UIViewController, DragDropBehaviorDelegate {
    var groupTitle : String
    var tasks : [String]
    
    var startTime : NSTimeInterval
    var timer : NSTimer
    
    required init(coder aDecoder: NSCoder) {
        groupTitle = String()
        tasks = [String]()
        timer = NSTimer()
        startTime = NSTimeInterval()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardView: DesignableView!
    @IBOutlet weak var task: SpringLabel!
    
    @IBOutlet var displayTimeLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        task.text = tasks[0]
        cardTitle.text = groupTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func start(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

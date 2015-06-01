//
//  TaskTableViewController.swift
//  Routinely
//
//  Created by Torin Blankensmith on 4/7/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.


import UIKit

class TaskTableViewController: RoutineTableViewController {

    var tasks : [String]
    
    required init(coder aDecoder: NSCoder) {
        tasks = [String]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
        self.tableView.backgroundColor = UIColor(white: 0, alpha: 1)
        let pinch = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.tableView.addGestureRecognizer(pinch)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tasks.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("start", forIndexPath: indexPath) as! UITableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
            cell.textLabel?.backgroundColor = UIColor.clearColor()
            cell.delegate = self
            cell.routineItem = Routine(text: tasks[indexPath.row - 1])

            return cell
        }
        // Configure the cell...
    }
    
    // MARK: - pinch methods
    struct TouchPoints {
        var upper: CGPoint
        var lower: CGPoint
    }
    // the indices of the upper and lower cells that are being pinched
    var upperCellIndex = -100
    var lowerCellIndex = -100
    // the location of the touch points when the pinch began
    var initialTouchPoints: TouchPoints!
    // indicates that the pinch was big enough to cause a new item to be added
    var pinchExceededRequiredDistance = false
    
    var pinchInProgress = false
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            performSegueWithIdentifier("unwindSegue", sender: self)
//            pinchStarted(recognizer)
        case .Changed :
            if pinchInProgress && recognizer.numberOfTouches() == 2 {
                pinchChanged(recognizer)
            }
        case .Ended:
            pinchEnded(recognizer)
        default:
            break
        }
    }
    
    func pinchStarted(recognizer: UIPinchGestureRecognizer) {

    }
    
    func pinchChanged(recognizer: UIPinchGestureRecognizer) {
        
    }
    
    func pinchEnded(recognizer: UIPinchGestureRecognizer) {
        
    }
    
    // returns the two touch points, ordering them to ensure that
    // upper and lower are correctly identified.
    func getNormalizedTouchPoints(recognizer: UIGestureRecognizer) -> TouchPoints {
        var pointOne = recognizer.locationOfTouch(0, inView: tableView)
        var pointTwo = recognizer.locationOfTouch(1, inView: tableView)
        // ensure pointOne is the top-most
        if pointOne.y > pointTwo.y {
            let temp = pointOne
            pointOne = pointTwo
            pointTwo = temp
        }
        return TouchPoints(upper: pointOne, lower: pointTwo)
    }
    
    func viewContainsPoint(view: UIView, point: CGPoint) -> Bool {
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
    }
    
//    override func cellDidBeginEditing(editingCell: TableViewCell) {
//        cellSaveState = editingCell.label.text
//    }

//    override func cellDidEndEditing(editingCell: TableViewCell) {
//        if editingCell.label.text != cellSaveState {
//            let index = find(tasks, cellSaveState)
////            routineItems[index!] = editingCell.label.text
//        }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentCardViewSegue" {
            let view = segue.destinationViewController as! CardViewController
            NSLog(navigationItem.title!)
            view.groupTitle = navigationItem.title!
            NSLog(tasks.count.description)
            view.tasks = self.tasks
            // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller.
        }
    }

}

//
//  RoutineTableViewController.swift
//  Routinely
//
//  Created by Torin Blankensmith on 4/7/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.
//

import UIKit

class RoutineTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var routineItems : [String]
    var routineDict : [String: [String]]
    var cellSaveState : String
    
    required init(coder aDecoder: NSCoder) {
        routineItems = [String]()
        routineDict = [String: [String]]()
        let item1 = "Rock Climbing Hangboard"
        let item2 = "Oranges"
        let item3 = "Kale"
        let item4 = "Milk"
        let item5 = "Yogurt"
        let item6 = "Crackers"
        let item7 = "Cheese"
        let item8 = "Carrots"
        let item9 = "Ice Cream"
        let item10 = "Olive Oil"
        routineItems.append(item1)
        routineItems.append(item2)
        
        routineItems.append(item3)
        routineItems.append(item4)
        routineItems.append(item5)
        routineItems.append(item6)
        routineItems.append(item7)
        routineItems.append(item8)
        routineItems.append(item9)
        routineItems.append(item10)
        for item in routineItems{
            routineDict[item] = ["40s Jug Hang", "7 Jug Pullups", "7 Medium Pullups", "7 Small Pullups"]
        }
        cellSaveState = String()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer){
        let longPress = gestureRecognizer as UILongPressGestureRecognizer

        var locationInView = longPress.locationInView(tableView)
        var indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        let state = longPress.state
        switch state {
        case UIGestureRecognizerState.Began:
            NSLog("GESTURE Began")
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                // Take a snapshot of the selected row using helper method
                My.cellSnapshot = snapshotOfCell(cell)

                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    // Offset for gesture location
                    center.y = locationInView.y
                    
                    My.cellSnapshot!.center = center
                    
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    
                    My.cellSnapshot!.alpha = 0.98
                    // Fade out
                    cell.alpha = 0.0
                    
                }, completion: {(finished) -> Void in
                    if finished {
                        cell.hidden = true
                    }
                })
            }
            break
            
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            // is destination valid and differant than the source?
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                var temp = routineItems[indexPath!.row]
                routineItems[Path.initialIndexPath!.row] = routineItems[indexPath!.row]
                routineItems[indexPath!.row] = temp
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
            break
        default:
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                        
                    }
            })
        }

    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return routineItems.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        cell.label?.text = routineItems[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            routineItems.removeAtIndex(indexPath.item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = routineItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    func cellDidBeginEditing(editingCell: TableViewCell) {
        cellSaveState = editingCell.label.text
    }
    
    func cellDidEndEditing(editingCell: TableViewCell) {
        if editingCell.label.text != cellSaveState {
            let index = find(routineItems, cellSaveState)
            let backup = routineDict[cellSaveState]
            routineDict[cellSaveState] = nil
            routineDict[editingCell.label.text] = backup
            routineItems[index!] = editingCell.label.text
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let newView = segue.destinationViewController as UIViewController
        let cell = sender as TableViewCell!
        newView.navigationItem.title = cell.label?.text
        
        var index : String
        index = cell.label!.text!
        let taskList = routineDict[index]
        
        let view = segue.destinationViewController as TaskTableViewController
        view.tasks = taskList!
        
//        view.tasks = routineDict[cell.label!.text!]!
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}

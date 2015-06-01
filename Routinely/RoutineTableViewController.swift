//
//  RoutineTableViewController.swift
//  Routinely
//
//  Created by Torin Blankensmith on 4/7/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.
//

import UIKit

class RoutineTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    
    var routineItems : [Routine]
    var routineDict : [String: [String]]
    var saveState : String
    
    required init(coder aDecoder: NSCoder) {
        routineItems = [Routine]()
        routineDict = [String: [String]]()
        
        routineItems.append(Routine(text: "Rock Climbing Workout"))
        routineItems.append(Routine(text: "Leg Day Workout"))
        routineItems.append(Routine(text: "Chest Workout"))
        routineItems.append(Routine(text: "Core Workout"))

        for item in routineItems{
            routineDict[item.text] = ["40s Hang", "10 Pullups", "10 Pullups Reverse Grip", "10 Pullups"]
        }
        saveState = ""
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.backgroundColor = UIColor(white: 0, alpha: 1)
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer

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
    
    // MARK: - Table view data source
    // contains numberOfSectionsInTableView, numberOfRowsInSection, cellForRowAtIndexPath

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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)as! TableViewCell
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.delegate = self
        cell.routineItem = routineItems[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog(routineItems[indexPath.row].text)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        performSegueWithIdentifier("tasksSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
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
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    let placeHolderCell = TableViewCell(style: .Default, reuseIdentifier: "Cell")
    // indicates the state of this behavior
    var pullDownInProgress = false
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        placeHolderCell.backgroundColor = UIColor.redColor()
        if pullDownInProgress {
            // add the placeholder
            tableView.insertSubview(placeHolderCell, atIndex: 0)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollViewContentOffsetY = scrollView.contentOffset.y
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
            // maintain the location of the placeholder
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight,
                width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.label.text = -scrollViewContentOffsetY > tableView.rowHeight ?
                "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        } else {
            pullDownInProgress = false
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight {
            routineItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    // MARK: - TableViewDelegate methods
    // contains willDisplayCell and your helper method colorForIndex
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = routineItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    
    func cellDidBeginEditing(editingCell: TableViewCell) {
        var editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        saveState = editingCell.label.text
        for cell in visibleCells {
            UIView.animateWithDuration(0.3, animations: {() in
                cell.transform = CGAffineTransformMakeTranslation(0, editingOffset)
                if cell != editingCell {
                    cell.alpha = 0.3
                }
                
            })
        }
    }
    
    func cellDidEndEditing(editingCell: TableViewCell) {
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        for cell: TableViewCell in visibleCells {
            UIView.animateWithDuration(0.3, animations: {() in
                cell.transform = CGAffineTransformIdentity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
        if editingCell.routineItem!.text == "" {
            routineItemDeleted(editingCell.routineItem!)
        } else {
            if let index = routineDict.indexForKey(saveState) {
                routineDict.removeAtIndex(index)
            }
        }
    }
    
    func routineItemDeleted(routineItem: Routine) {
        let index = (routineItems as NSArray).indexOfObject(routineItem)
        if index == NSNotFound {
            return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        routineItems.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()    
    }
    
    
    
    // MARK: - add, delete, edit methods
    func routineItemAdded() {
        let routineItem = Routine(text: "")
        routineItems.insert(routineItem, atIndex: 0)
        tableView.reloadData()
        // enter edit mode
        var editCell: TableViewCell
        let visibleCells = tableView.visibleCells() as! [TableViewCell]
        for cell in visibleCells {
            if (cell.routineItem === routineItem) {
                editCell = cell
                editCell.label.becomeFirstResponder()
                break
            }
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tasksSegue" {
            let cell = sender as! TableViewCell!
            let index = routineDict.indexForKey(cell.routineItem!.text)
            let taskList = routineDict[index!]
            let view = segue.destinationViewController as! TaskTableViewController
            view.tasks = taskList.1
            view.navigationItem.title = cell.routineItem!.text
        }

        
//        view.tasks = routineDict[cell.label!.text!]!
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}

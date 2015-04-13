//
//  TaskTableViewController.swift
//  Routinely
//
//  Created by Torin Blankensmith on 4/7/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.
//

import UIKit

class TaskTableViewController: RoutineTableViewController {

    var tasks : [String]
    
    required init(coder aDecoder: NSCoder) {
        tasks = [String]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        cell.label?.text = tasks[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func cellDidBeginEditing(editingCell: TableViewCell) {
        cellSaveState = editingCell.label.text
    }

    override func cellDidEndEditing(editingCell: TableViewCell) {
        if editingCell.label.text != cellSaveState {
            let index = find(tasks, cellSaveState)
            routineItems[index!] = editingCell.label.text
        }
    }

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
        let view = segue.destinationViewController as CardViewController
        NSLog(navigationItem.title!)
        view.groupTitle = navigationItem.title!
        NSLog(tasks.count.description)
        view.tasks = self.tasks
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}

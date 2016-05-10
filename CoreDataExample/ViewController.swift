//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Dante Solorio on 5/9/16.
//  Copyright © 2016 Dasoga. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableList: UITableView!
    
    var elements:[String] = []
    var tasks = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            tasks = results as! [NSManagedObject]
            
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func addAction(sender:AnyObject){
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveTask(textField!.text!)
                                        self.tableList.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    //MARK: - Gerenal functions
    
    func saveTask(taskString:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: managedContext)
        
        let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        task.setValue(taskString, forKey: "task")
        
        do{
            try managedContext.save()
            tasks.append(task)
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableList.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.valueForKey("task") as? String
        return cell
    }


}



//
//  Created by Mathias Ratzesberger on 21.07.15.
//  Copyright (c) 2015 Mara-Consulting. All rights reserved.
//
import XLForm
protocol ProjectOverviewDelegate{
    func updateForm()
}

class ProjectDetail : XLFormViewController {
    var delegate:ProjectOverview? = nil
    var createMode:Bool = false
    
    private struct Tags {
        static let ProjectName = "ProjectName"
        static let ProjectDescription = "ProjectDescription"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        if (!user.ProjectSelected["ProjectId"]){
            self.createMode = true
        }else{
            self.createMode = false
        }
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        user.getUserProjects(initializeForm)
        //        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if (!user.ProjectSelected["ProjectId"]){
            self.createMode = true
        }else{
            self.createMode = false
        }
        super.init(coder: aDecoder)
        user.getUserProjects(initializeForm)
        //        initializeForm()
    }
    
    
    // MARK: Helpers
    
    func initializeForm(done:Bool) {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        //        XLFormViewController.cellClassesForRowDescriptorTypes()
        //            .setObject("OTRResources.bundle/OTRUsernameCell",
        //                forKey: OTRUsernameCell.)
        
        form = XLFormDescriptor()
        form.disabled = true
    
        section = XLFormSectionDescriptor.formSectionWithTitle("Projekt Daten")
//        section = XLFormSectionDescriptor.formSectionWithTitle("test", sectionOptions: XLFormSectionOptions.CanInsert)
        form.addFormSection(section)
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.ProjectName, rowType: XLFormRowDescriptorTypeText, title: "Projekt Name")
        row.required = true
//        row.cellConfigAtConfigure["textField.placeholder"] = "Projekt Name"
        row.value = user.ProjectSelected["ProjectName"].string
        section.addFormRow(row)
        // Description
        row = XLFormRowDescriptor(tag: Tags.ProjectDescription, rowType: XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "Beschreibung"
        row.value = user.ProjectSelected["ProjectDescription"].string
        section.addFormRow(row)
//        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        self.form = form
        if (self.createMode){
            editPressed(navigationItem.rightBarButtonItem!)
        }
    }
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        // change cell height of a particular cell
    //        if form.formRowAtIndex(indexPath)?.tag == Tags.ProjectDescription {
    //            return 120.0
    //        }
    //        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    //    }
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        // change cell height
    //            return 60.0
    //    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPressed:")

    }
    func editPressed(button: UIBarButtonItem)
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "savePressed:")
        self.form.disabled = false
        self.tableView.reloadData()
    }
    func savePressed(button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            //            self.showFormValidationError(validationErrors.first)
            //            return
            let alertController = UIAlertController(title: "Fehler", message: "Bitte geben Sie einen Namen ein.", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
            
        }else{
            self.tableView.endEditing(true)
//            user.ProjectSelected.dictionary?.values = [
//                "ProjectName":((self.form.formRowWithTag(Tags.ProjectName)!.value) as? String)!,
//                "ProjectDescription":((self.form.formRowWithTag(Tags.ProjectDescription)!.value) as? String)!
//            ]
            user.ProjectSelected["ProjectName"].string = ((self.form.formRowWithTag(Tags.ProjectName)!.value) as? String)!
            user.ProjectSelected["ProjectDescription"].string = ((self.form.formRowWithTag(Tags.ProjectDescription)!.value) as? String)!
            user.setProjectData(handleSetData)
        }
    }
    func handleSetData(done:Bool){
        if (done){
            self.tableView.endEditing(true)
            
            let alertController = UIAlertController(title: "Erfolg", message: "Daten wurden erfolgreich geändert", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPressed:")
            self.form.disabled = true
            self.tableView.reloadData()
            
            if (delegate != nil) {
                delegate!.updateForm()
            }
        }else{
            let alertController = UIAlertController(title: "Fehler", message: "Ein Fehler ist aufgetreten, bitte versuche es später noch mal.", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
}


//
//  Created by Mathias Ratzesberger on 21.07.15.
//  Copyright (c) 2015 Mara-Consulting. All rights reserved.
//
import XLForm

class ProjectOverview : XLFormViewController {
    
    private struct Tags {
        static let ProjectName = "ProjectName"
        static let ProjectDescription = "ProjectDescription"
        static let ProjectAdd = "ProjectAdd"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        user.getUserProjects(initializeForm)
        //        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        user.getUserProjects(initializeForm)
        //        initializeForm()
    }
    
    
    // MARK: Helpers
    
    func initializeForm(done:Bool) {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        var label: UILabel
        
        label = UILabel()
//        label.FAIcon = FAType.FAPlusCircle
        label.setFAIcon(FAType.FAPlusCircle, iconSize: 25)
        label.textColor = UIColor.greenColor()
        label.textAlignment = NSTextAlignment.Center
        
        form = XLFormDescriptor()
        form.disabled = false
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Meine Projekte")
//        section = XLFormSectionDescriptor.formSectionWithTitle("test", sectionOptions: XLFormSectionOptions.CanInsert)
        form.addFormSection(section)
        
        for (_,subJson):(String, JSON) in user.Projects {
            // Project Name
            row = XLFormRowDescriptor(tag: Tags.ProjectName, rowType: XLFormRowDescriptorTypeButton, title: subJson["ProjectName"].string)
//            row.cellStyle = UITableViewCellStyle.Subtitle
            row.action.formSegueIdenfifier = "ProjectDetail"
            section.addFormRow(row)
        }
        row = XLFormRowDescriptor(tag: Tags.ProjectName, rowType: XLFormRowDescriptorTypeButton)
        row.cellConfig["textLabel.font"] = label.font
        row.cellConfig["textLabel.text"] = label.text
        row.cellConfig["textLabel.textColor"] = label.textColor
        row.cellConfig["textLabel.textAlignment"] = label.textAlignment.hashValue
        row.action.formSegueIdenfifier = "ProjectDetail"
        section.addFormRow(row)
        //        form.addFormSection(section)
        //        section = XLFormSectionDescriptor.formSectionWithTitle("Meine Projekte")
        //        form.addFormSection(section)
        //        for (_,subJson):(String, JSON) in user.Projects {
        //            // Project Name
        //            row = XLFormRowDescriptor(tag: Tags.ProjectName, rowType: XLFormRowDescriptorTypeButton, title: subJson["ProjectName"].string)
        //            row.cellStyle = UITableViewCellStyle.Subtitle
        //            row.action.formSegueIdenfifier = "ProjectSegue"
        //            section.addFormRow(row)
        //        }
        form.addFormSection(section)
        
        self.form = form
    }
    func updateForm() {
        user.getUserProjects(initializeForm)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let vc = segue.destinationViewController as! ProjectDetail
        vc.delegate = self
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let Project = user.Projects[indexPath.row]
        if (!Project.isEmpty){
            user.ProjectSelected = Project
        }else{
            user.ProjectSelected = JSON(["ProjectId":"", "ProjectName":"","ProjectDescription":""])
        }
        
        NSLog("Navigate to Project: \(Project)")
        performSegueWithIdentifier("ProjectDetail", sender: self)
    }
    
}

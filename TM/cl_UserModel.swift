//
//  cl_UserModel.swift
//  smap
//
//  Created by Mathias Ratzesberger on 17.04.15.
//  Copyright (c) 2015 Mara-Consulting. All rights reserved.
//

import UIKit

class cl_UserModel{
    var UserId: String = ""
    var DeviceId: String
    var DeviceName: String
    var DeviceModel: String
    var DeviceLocModel: String
    var DeviceSysName: String
    var DeviceSysVersion: String
    var firstName: String = ""
    var lastName: String = ""
    var Name: String = ""
    var nickName: String = ""
    var email: String = ""
    var Projects: JSON = nil
    var ProjectSelected: JSON = nil
    private var dbModel: cl_DBModel = cl_DBModel.getInstance( )
    // id init
    init( ) {
        self.DeviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        self.DeviceName = UIDevice.currentDevice().name
        self.DeviceModel = UIDevice.currentDevice().model
        self.DeviceLocModel = UIDevice.currentDevice().localizedModel
        self.DeviceSysName = UIDevice.currentDevice().systemName
        self.DeviceSysVersion = UIDevice.currentDevice().systemVersion
        self.getUserData(){ done in
        }
    }
    
    func getUserData(callback: ((done: Bool)->Void)?) {
        
        let url = servcieURLs + "GetUserData"
        
        let parameters:[String : String] = [
            "DeviceId": self.DeviceId,
            "DeviceName": self.DeviceName,
            "DeviceModel": self.DeviceModel,
            "DeviceLocModel": self.DeviceLocModel,
            "DeviceSysName": self.DeviceSysName,
            "DeviceSysVersion": self.DeviceSysVersion
        ]
        
        self.dbModel.getUserData(url, parameter: parameters){ done, response in
            
            self.nickName = response!["UserNick"].stringValue
            self.Name = response!["UserName"].stringValue
            self.UserId = response!["UserId"].stringValue
            callback?(done: done)
            
        }
    }
    func setUserData(callback: ((done: Bool)->Void)?) {
        
        let url = servcieURLs + "SetUserData"
        let dataCols:[String : String] = [
            "UserNick": self.nickName,
            "UserName": self.Name
        ]
        let parameters:[String : AnyObject] = [
            "UserId": self.UserId,
            "DataCols": dataCols
        ]
        self.dbModel.setUserData(url, parameter: parameters){ done, response in
                callback?(done: done)
        }
    }
    func getUserProjects(callback: ((done: Bool)->Void)?) {
        if (self.UserId == ""){
            self.getUserData(){ done in
                let url = servcieURLs + "GetProjectData"
                let parameters:[String : AnyObject] = [
                    "UserId": self.UserId
                ]
                self.dbModel.getUserData(url, parameter: parameters){ done, response in
                    self.Projects = response!["Projects"]
                    callback?(done: done)
                }
            }
        }else{
            let url = servcieURLs + "GetProjectData"
            let parameters:[String : AnyObject] = [
                "UserId": self.UserId
            ]
            self.dbModel.getUserData(url, parameter: parameters){ done, response in
                self.Projects = response!["Projects"]
                callback?(done: done)
            }
        }

    }
    func setProjectData(callback: ((done: Bool)->Void)?) {
        
        let url = servcieURLs + "SetProjectData"
        let dataCols:[String : String] = [
            "ProjectName": self.ProjectSelected["ProjectName"].string!,
            "ProjectDescription": self.ProjectSelected["ProjectDescription"].string!
        ]
        let parameters:[String : AnyObject] = [
            "UserId": self.UserId,
            "ProjectId": self.ProjectSelected["ProjectId"].string!,
            "DataCols": dataCols
        ]
        self.dbModel.setUserData(url, parameter: parameters){ done, response in
            callback?(done: done)
        }
    }
}

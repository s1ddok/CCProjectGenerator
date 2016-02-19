//
//  ViewController.swift
//  CCProjectGenerator
//
//  Created by Andrey Volodin on 18.02.16.
//  Copyright © 2016 cocos2d. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var createButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func createButtonPressed(sender: AnyObject) {
        let saveDialog = NSSavePanel()
        
        saveDialog.beginSheetModalForWindow(NSApplication.sharedApplication().mainWindow!) { (result: Int) -> Void in
            if result == NSModalResponseOK {
                var fileName = saveDialog.URL!.path!
                let fileNameRaw = (fileName as NSString).stringByDeletingPathExtension
                
                //check validity
                let validChars = NSCharacterSet.alphanumericCharacterSet().mutableCopy() as! NSMutableCharacterSet
                validChars.addCharactersInString("_")
                let invalidChars = validChars.invertedSet
                
                let lastPathComponent = (fileNameRaw as NSString).lastPathComponent
                if lastPathComponent.rangeOfCharacterFromSet(invalidChars) == nil {
                    
                    fileName = fileName + "/" + lastPathComponent + ".ccbproj"
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), { () -> Void in
                        
                        CCBProjectCreator.createDefaultProjectAtPath(fileName, programmingLanguage: .Swift)
                        
                    })
                    
                }
            }
            
        }
    }
}


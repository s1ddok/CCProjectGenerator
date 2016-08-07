//
//  ViewController.swift
//  CCProjectGenerator
//
//  Created by Andrey Volodin on 18.02.16.
//  Copyright © 2016 cocos2d. All rights reserved.
//

import Cocoa
import Foundation

typealias AttributedString = Foundation.NSAttributedString

class ViewController: NSViewController {

    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var chipmunkCheckbox: NSButton!
    @IBOutlet weak var ccbCheckbox: NSButton!
    @IBOutlet weak var langSelector: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set fancy black background color
        let viewLayer = CALayer()
        viewLayer.backgroundColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        view.wantsLayer = true
        view.layer = viewLayer
        
        // Color label
        chipmunkCheckbox.attributedTitle = AttributedString(string: chipmunkCheckbox.title, attributes: [NSForegroundColorAttributeName : NSColor.white])
        
        ccbCheckbox.attributedTitle = AttributedString(string: ccbCheckbox.title, attributes: [NSForegroundColorAttributeName : NSColor.white])
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func createButtonPressed(_ sender: AnyObject) {
        let saveDialog = NSSavePanel()
        
        saveDialog.beginSheetModal(for: NSApplication.shared().mainWindow!) { (result: Int) -> Void in
            if result == NSModalResponseOK {
                var fileName = saveDialog.url!.path
                let fileNameRaw = (fileName as NSString).deletingPathExtension
                
                //check validity
                let validChars = NSMutableCharacterSet.alphanumeric()
                validChars.addCharacters(in: "_- ")
                let invalidChars = validChars.inverted
                
                let lastPathComponent = (fileNameRaw as NSString).lastPathComponent
                if lastPathComponent.rangeOfCharacter(from: invalidChars) == nil {
                    
                    fileName = fileName + "/" + lastPathComponent + ".ccbproj"
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0) / Double(NSEC_PER_SEC), execute: { () -> Void in
                        let lang = CCBProgrammingLanguage(rawValue: Int8(self.langSelector.selectedItem!.tag))
                        CCBProjectCreator.createDefaultProject(atPath: fileName, withChipmunk: self.chipmunkCheckbox.state == NSOnState, withCCB: self.ccbCheckbox.state == NSOnState, programmingLanguage:lang!)
                    })
                    
                }
            }
            
        }
    }
}


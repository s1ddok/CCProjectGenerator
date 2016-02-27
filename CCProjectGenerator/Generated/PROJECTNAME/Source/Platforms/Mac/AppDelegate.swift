/*
* Cocos2D : http://cocos2d-objc.org
*
* Copyright (c) 2016 Volodin Andrey
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var glView: CCGLView!
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        // Get the director
        let director = CCDirector.sharedDirector() as! CCDirectorMac
        
        // enable FPS and SPF
        director.displayStats = true
        
        let defaultWinSize = CGSizeMake(480, 320)
        window.setFrame(CGRect(origin: CGPointZero, size: defaultWinSize), display: true)
        glView.frame = window.frame
        
        director.view = glView
        // 'Effects' don't work correctly when autoscale is turned on.
        // Use kCCDirectorResize_NoScale if you don't want auto-scaling.
        //director.resizeMode = Int32(kCCDirectorResize_NoScale)
        
        window.acceptsMouseMovedEvents = false
        window.center()
        
        // File extensions
        // You can use anything you want, and completely dropping extensions will in most cases automatically scale the artwork correct
        // To make it easy to understand what resolutions I am using, I have changed this for this demo to -4x -2x and -1x
        // Notice that I deliberately added some of the artwork without extensions
        CCFileUtils.sharedFileUtils().suffixesDict = [CCFileUtilsSuffixiPad : "-2x",
            CCFileUtilsSuffixiPadHD    : "-4x",
            CCFileUtilsSuffixiPhone    : "-1x",
            CCFileUtilsSuffixiPhoneHD  : "-1x",
            CCFileUtilsSuffixiPhone5   : "-1x",
            CCFileUtilsSuffixiPhone5HD : "-2x",
            CCFileUtilsSuffixDefault   : ""]
        
        // Call this instead of line above if you are using SpriteBuilder
        //CCBReader.configureCCFileUtils()
        
        // Create a scene
        let mainScene = MainScene()
        
        // Run the director with the initial scene
        director.runWithScene(mainScene)
    }
    
}

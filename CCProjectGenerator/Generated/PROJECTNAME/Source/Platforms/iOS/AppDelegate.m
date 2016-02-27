/*
 * Cocos2D : http://cocos2d-objc.org
 *
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

#import "cocos2d.h"

#import "AppDelegate.h"
#if CC_CCBREADER
#import "CCBuilderReader.h"
#endif
#import "MainScene.h"


@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary* cocos2dSetup;
#if CC_CCBREADER
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
#else
    // Cocos2D takes a dictionary to start ... yeah I know ... but it does, and it is kind of neat
    cocos2dSetup = [NSMutableDictionary dictionary];
    
    // Let's add some setup stuff
    
    // File extensions
    // You can use anything you want, and completely dropping extensions will in most cases automatically scale the artwork correct
    // To make it easy to understand what resolutions I am using, I have changed this for this demo to -4x -2x and -1x
    // Notice that I deliberately added some of the artwork without extensions
    [CCFileUtils sharedFileUtils].suffixesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  @"-2x", CCFileUtilsSuffixiPad,
                                                  @"-4x", CCFileUtilsSuffixiPadHD,
                                                  @"-1x", CCFileUtilsSuffixiPhone,
                                                  @"-1x", CCFileUtilsSuffixiPhoneHD,
                                                  @"-1x", CCFileUtilsSuffixiPhone5,
                                                  @"-2x", CCFileUtilsSuffixiPhone5HD,
                                                  @"", CCFileUtilsSuffixDefault,
                                                  nil];
    
    // Call this instead of line above if you are using SpriteBuilder
    //[CCBReader configureCCFileUtils];
    
    // Show FPS
    // We really want this when developing an app
    [cocos2dSetup setObject:@(YES) forKey:CCSetupShowDebugStats];
    
    // A acouple of other examples
    
    // Use a 16 bit color buffer
    // This will lower the color depth from 32 bits to 16 bits for that extra performance
    // Most will want 32, so we disbaled it
    // ---
    // [startUpOptions setObject:kEAGLColorFormatRGB565 forKey:CCSetupPixelFormat];
    
    // Use a simplified coordinate system that is shared across devices
    // Normally you work in the coordinate of the device (an iPad is 1024x768, an iPhone 4 480x320 and so on)
    // This feature makes it easier to use the same setup for all devices (easier is a relative term)
    // Most will want to handle iPad and iPhone exclusively, so it is disabled by default
    // ---
    // [startUpOptions setObject:CCScreenModeFixed forKey:CCSetupScreenMode];
    
    // All the supported keys can be found in CCConfiguration.h
#endif
    // We are done ...
    // Lets get this thing on the road!
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    
    // Creat a scene
    CCScene* main = [MainScene new];
    
    // Run the director with the scene.
    // Push as much scenes as you want (maybe useful for 3D touch)
    [director runWithScene:main];
    
    // Stay positive. Always return a YES :)
    return YES;
}

@end

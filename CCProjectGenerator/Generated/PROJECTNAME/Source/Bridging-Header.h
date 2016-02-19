#import "cocos2d.h"
#import "cocos2d-ui.h"

// Imported explicitly and with relative path.
// Class would otherwise be available but not autocompleting/syntax-highlighting.
// Perhaps an Xcode bug?
#import "libs/cocos2d/Support/CCColor.h"
#if CC_CCBREADER
#import "libs/cocos2d-ui/CCBReader/CCBReader.h"
#endif
#import "libs/cocos2d-ui/CCControl.h"
#import "libs/cocos2d-ui/CCButton.h"
#import "libs/cocos2d-ui/CCSlider.h"
#import "libs/cocos2d-ui/CCTextField.h"

#import "MainScene.h"

@implementation MainScene

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    // Background
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"ic_launcher.png"];
    sprite.position = ccp(0.5, 0.5);
    sprite.positionType = CCPositionTypeNormalized;
    [self addChild:sprite];
    
    // The standard Hello World text
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"ArialMT" fontSize:16];
    label.positionType = CCPositionTypeNormalized;
    label.position = (CGPoint){0.5, 0.25};
    [self addChild:label];
    
    // done
    return self;
}
@end

//
//  CCBProjectCreator.h
//  SpriteBuilder
//
//  Created by Viktor on 10/11/13.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int8_t, CCBProgrammingLanguage)
{
    CCBProgrammingLanguageObjectiveC = 1,
    CCBProgrammingLanguageSwift = 2,
};


@interface CCBProjectCreator : NSObject

+ (BOOL) createDefaultProjectAtPath:(NSString*)fileName withChipmunk:(BOOL)withChipmunk programmingLanguage:(CCBProgrammingLanguage)language;

@end

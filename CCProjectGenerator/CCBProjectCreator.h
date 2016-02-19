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
    CCBProgrammingLanguageObjectiveC = 0,
    CCBProgrammingLanguageSwift = 1,
};


@interface CCBProjectCreator : NSObject

+ (BOOL) createDefaultProjectAtPath:(NSString*)fileName programmingLanguage:(CCBProgrammingLanguage)language;

@end

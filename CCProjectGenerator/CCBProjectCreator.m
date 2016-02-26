//
//  CCBProjectCreator.m
//  SpriteBuilder
//
//  Created by Viktor on 10/11/13.
//
//

#import "CCBProjectCreator.h"
#import <Foundation/Foundation.h>

@interface NSString (IdentifierSanitizer)

- (NSString *)sanitizedIdentifier;

@end

@implementation NSString (IdentifierSanitizer)

- (NSString *)sanitizedIdentifier
{
    NSString* identifier = [self stringByTrimmingCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]];
    NSMutableString* sanitized = [NSMutableString new];
    
    for (int idx = 0; idx < [identifier length]; idx++)
    {
        unichar ch = [identifier characterAtIndex:idx];
        if (!isalpha(ch))
        {
            ch = '_';
        }
        [sanitized appendString:[NSString stringWithCharacters:&ch length:1]];
    }
    
    NSString *trimmed = [sanitized stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    if ([trimmed length] == 0)
    {
        trimmed = @"identifier";
    }
    
    return trimmed;
}

@end

@implementation CCBProjectCreator

+(BOOL) createDefaultProjectAtPath:(NSString*)fileName withChipmunk:(BOOL)withChipmunk withCCB:(BOOL)withCCB programmingLanguage:(CCBProgrammingLanguage)programmingLanguage
{
    NSError *error = nil;
    NSFileManager* fm = [NSFileManager defaultManager];
    
	NSString* substitutableProjectName = @"PROJECTNAME";
    NSString* substitutableProjectIdentifier = @"PROJECTIDENTIFIER";
    NSString* parentPath = [fileName stringByDeletingLastPathComponent];
    
    NSError* err = nil;
    [fm copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Generated/PROJECTNAME"] toPath:parentPath error:&err];
    
    // Rename ccbproj
	NSString* ccbproj = [NSString stringWithFormat:@"%@.ccbproj", substitutableProjectName];
    
    // Update the Xcode project
    NSString* xcodeproj = [NSString stringWithFormat:withChipmunk ? @"%@+Chipmunk.xcodeproj" : @"%@.xcodeproj", substitutableProjectName];
    NSString* configFile = [parentPath stringByAppendingPathComponent:@"Source/libs/cocos2d/ccConfig.h"];
    NSString* xcodeFileName = [parentPath stringByAppendingPathComponent:xcodeproj];
    NSString* projName = [[fileName lastPathComponent] stringByDeletingPathExtension];
    NSString* identifier = [projName sanitizedIdentifier];
    
    // Update the project
    NSString *pbxprojFile = [xcodeFileName stringByAppendingPathComponent:@"project.pbxproj"];
    [self setName:projName inFile:pbxprojFile search:substitutableProjectName];
    [self setName:identifier inFile:pbxprojFile search:substitutableProjectIdentifier];
    NSMutableArray *filesToRemove = [NSMutableArray array];
    if (programmingLanguage == CCBProgrammingLanguageObjectiveC)
    {
        [self setName:@"IPHONEOS_DEPLOYMENT_TARGET = 6.0"
               inFile:pbxprojFile
               search:@"IPHONEOS_DEPLOYMENT_TARGET = 7.0"];
        [self setName:@"MACOSX_DEPLOYMENT_TARGET = 10.9"
               inFile:pbxprojFile
               search:@"MACOSX_DEPLOYMENT_TARGET = 10.10"];
        [self removeLinesMatching:@".*MainScene[.]swift.*" inFile:pbxprojFile];
        [self removeLinesMatching:@".*AppDelegate[.]swift.*" inFile:pbxprojFile];
        [filesToRemove addObjectsFromArray: @[@"Source/MainScene.swift", @"Source/Platforms/iOS/AppDelegate.swift", @"Source/Platforms/Mac/AppDelegate.swift"]];
    }
    else if (programmingLanguage == CCBProgrammingLanguageSwift)
    {
        [self removeLinesMatching:@".*MainScene[.][hm].*" inFile:pbxprojFile];
        [self removeLinesMatching:@".* AppDelegate[.][hm].*" inFile:pbxprojFile];
        [self removeLinesMatching:@".*main[.][m].*" inFile:pbxprojFile];
        [filesToRemove addObjectsFromArray:  @[@"Source/MainScene.h", @"Source/MainScene.m", @"Source/Platforms/iOS/AppDelegate.h", @"Source/Platforms/iOS/AppDelegate.m", @"Source/Platforms/iOS/main.m", @"Source/Platforms/Mac/AppDelegate.h", @"Source/Platforms/Mac/AppDelegate.m", @"Source/Platforms/Mac/main.m"]];
    }

    if (withChipmunk) {
        [filesToRemove addObject:[NSString stringWithFormat:@"%@.xcodeproj", substitutableProjectName]];
        
        [self setName:@"CC_PHYSICS 1" inFile:configFile search:@"CC_PHYSICS 0"];
        
    } else {
        [filesToRemove addObject:[NSString stringWithFormat:@"%@+Chipmunk.xcodeproj", substitutableProjectName]];
        [filesToRemove addObject:@"Source/libs/Chipmunk"];
        [filesToRemove addObject:@"Source/libs/cocos2d-ext/CCChipmunkPhysics"];
    }
    
    if (withCCB) {
        [self setName:@"CC_CCBREADER 1" inFile:configFile search:@"CC_CCBREADER 0"];
        
        [fm moveItemAtPath:[parentPath stringByAppendingPathComponent:ccbproj] toPath:fileName error:NULL];
    } else {
        [filesToRemove addObject:ccbproj];
        
        [filesToRemove addObject:@"Source/libs/cocos2d-ext/CCBReader"];
        [filesToRemove addObject:@"Source/Resources/Published-iOS"];
        [filesToRemove addObject:@"Packages"];
        
        [self removeSpriteBuilderFromFile:pbxprojFile];
    }
    
    
    
    
    for (NSString *file in filesToRemove)
    {
        if (![fm removeItemAtPath:[parentPath stringByAppendingPathComponent:file] error:&error])
        {
            return NO;
        }
    }

    // Update workspace data
    [self setName:projName inFile:[xcodeFileName stringByAppendingPathComponent:@"project.xcworkspace/contents.xcworkspacedata"] search:substitutableProjectName];
    
    NSArray *platforms = @[@"iOS", @"Mac", @"tvOS"];
    
    for (id platform in platforms) {
        // Update scheme
        NSString* templateScheme = [NSString stringWithFormat:@"xcshareddata/xcschemes/%@ %@.xcscheme", substitutableProjectName, platform];
        [self setName:projName inFile:[xcodeFileName stringByAppendingPathComponent:templateScheme] search:substitutableProjectName];

        // Rename scheme file
        NSString* schemeFile = [xcodeFileName stringByAppendingPathComponent:templateScheme];
        NSString* format = [@"iOS" isEqualToString:platform] ? @"%@" : @"%@ %@";  // we want iOS on top

        NSString* newSchemeFile = [[[schemeFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:format, projName, platform]]
            stringByAppendingPathExtension:@"xcscheme"];
        
        if (![fm moveItemAtPath:schemeFile toPath:newSchemeFile error:&error])
        {
            return NO;
        }

        // Update plist
        NSString* plistFileName = [parentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Source/Resources/Platforms/%@/Info.plist", platform]];
        [self setName:identifier inFile:plistFileName search:substitutableProjectIdentifier];
        [self setName:projName inFile:plistFileName search:substitutableProjectName];
    }

    // Rename Xcode project file
    NSString* newXcodeFileName = [[[xcodeFileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:projName] stringByAppendingPathExtension:@"xcodeproj"];
    
    [fm moveItemAtPath:xcodeFileName toPath:newXcodeFileName error:NULL];
    
    // Update Mac Xib file
    NSString* xibFileName = [parentPath stringByAppendingPathComponent:@"Source/Resources/Platforms/Mac/MainMenu.xib"];
    if (programmingLanguage == CCBProgrammingLanguageObjectiveC) {
        [self setName:@"" inFile:xibFileName search: @"customModule=\"PROJECTNAME\""];
    }
    [self setName:identifier inFile:xibFileName search:substitutableProjectIdentifier];
    [self setName:projName inFile:xibFileName search:substitutableProjectName];
	
	// perform cleanup to remove unnecessary files which only bloat the project
	//[CCBFileUtil cleanupSpriteBuilderProjectAtPath:fileName];
	
    return [fm fileExistsAtPath:fileName];
}

+ (void) setName:(NSString*)name inFile:(NSString*)fileName search:(NSString*)searchStr
{
    NSMutableData *fileData = [NSMutableData dataWithContentsOfFile:fileName];
    NSData *search = [searchStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *replacement = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSRange found;
    do {
        found = [fileData rangeOfData:search options:0 range:NSMakeRange(0, [fileData length])];
        if (found.location != NSNotFound)
        {
            [fileData replaceBytesInRange:found withBytes:[replacement bytes] length:[replacement length]];
        }
    } while (found.location != NSNotFound && found.length > 0);
    [fileData writeToFile:fileName atomically:YES];
}

+ (void) removeLinesMatching:(NSString*)pattern inFile:(NSString*)fileName
{
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *updatedString = [regex stringByReplacingMatchesInString:fileString
                                                         options:0
                                                           range:NSMakeRange(0, [fileString length])
                                                    withTemplate:@""];
    NSData *updatedFileData = [updatedString dataUsingEncoding:NSUTF8StringEncoding];
    [updatedFileData writeToFile:fileName atomically:YES];
}

+ (void) removeSpriteBuilderFromFile:(NSString*)fileName {
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSError* err;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"[A-Z0-9]{24}.{4}CCBReader \\*\\/ =.+?isa = PBXGroup.+?name = CCBReader;.+?\\};"
                                  options:NSRegularExpressionDotMatchesLineSeparators
                                  error:&err];
    
    NSString *updatedString = [regex stringByReplacingMatchesInString:fileString
                                                              options:0
                                                                range:NSMakeRange(0, [fileString length])
                                                         withTemplate:@""];
    
    for (NSString* pattern in @[@".*CCB[^u].*", @".*CCAnimationManager.*", @".*Published-iOS.*"]) {
        regex = [NSRegularExpression regularExpressionWithPattern:pattern options: NSRegularExpressionCaseInsensitive error:nil];
        updatedString = [regex stringByReplacingMatchesInString:updatedString
                                                        options:0
                                                          range:NSMakeRange(0, [updatedString length])
                                                   withTemplate:@""];
    }
    
    NSData *updatedFileData = [updatedString dataUsingEncoding:NSUTF8StringEncoding];
    [updatedFileData writeToFile:fileName atomically:YES];
}
@end

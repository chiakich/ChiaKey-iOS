//
// CKIOSChiaKeyPaths.h
//

#import <Foundation/Foundation.h>

@class CKIOSEnginePaths;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const CKIOSChiaKeyPathsErrorDomain;

@interface CKIOSChiaKeyPaths : NSObject

+ (nullable CKIOSEnginePaths *)enginePathsForBundle:(NSBundle *)bundle
                                appGroupIdentifier:(nullable NSString *)appGroupIdentifier
                                             error:(NSError **)error;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

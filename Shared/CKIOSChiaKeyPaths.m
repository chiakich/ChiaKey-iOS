//
// CKIOSChiaKeyPaths.m
//

#import "CKIOSChiaKeyPaths.h"

#import "CKIOSChiaKeyEngineBridge.h"

NSErrorDomain const CKIOSChiaKeyPathsErrorDomain =
    @"CKIOSChiaKeyPathsErrorDomain";

@implementation CKIOSChiaKeyPaths

+ (CKIOSEnginePaths *)enginePathsForBundle:(NSBundle *)bundle
                       appGroupIdentifier:(NSString *)appGroupIdentifier
                                    error:(NSError **)error {
  NSString *resourcePath = bundle.resourcePath ?: @"";
  NSString *lexiconPath = [bundle pathForResource:@"ChiaKeySource"
                                           ofType:@"db"];
  if (!lexiconPath.length) {
    if (error) {
      *error = [NSError errorWithDomain:CKIOSChiaKeyPathsErrorDomain
                                   code:1
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                     @"ChiaKeySource.db is missing from the bundle"
                               }];
    }
    return nil;
  }

  NSString *writablePath =
      [self writableSupportPathWithAppGroupIdentifier:appGroupIdentifier
                                                error:error];
  if (!writablePath.length) return nil;

  CKIOSEnginePaths *paths = [[CKIOSEnginePaths alloc] init];
  paths.loadedPath = resourcePath;
  paths.resourcePath = resourcePath;
  paths.writablePath = writablePath;
  paths.lexiconDatabasePath = lexiconPath;
  return paths;
}

+ (NSString *)writableSupportPathWithAppGroupIdentifier:(NSString *)identifier
                                                 error:(NSError **)error {
  NSFileManager *fileManager = NSFileManager.defaultManager;
  NSURL *baseURL = nil;
  if (identifier.length) {
    baseURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:
                              identifier];
  }

  if (!baseURL) {
    baseURL = [fileManager URLsForDirectory:NSApplicationSupportDirectory
                                  inDomains:NSUserDomainMask].firstObject;
  }

  NSURL *directoryURL =
      [baseURL URLByAppendingPathComponent:@"ChiaKey" isDirectory:YES];
  NSError *createError = nil;
  [fileManager createDirectoryAtURL:directoryURL
        withIntermediateDirectories:YES
                         attributes:nil
                              error:&createError];
  if (createError) {
    if (error) {
      *error = [NSError errorWithDomain:CKIOSChiaKeyPathsErrorDomain
                                   code:2
                               userInfo:@{
                                 NSLocalizedDescriptionKey :
                                     createError.localizedDescription
                               }];
    }
    return nil;
  }

  return directoryURL.path;
}

@end

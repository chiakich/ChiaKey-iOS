//
// CKIOSAppDelegate.m
//

#import "CKIOSAppDelegate.h"

#import "CKIOSRootViewController.h"

@implementation CKIOSAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  self.window.rootViewController = [[CKIOSRootViewController alloc] init];
  [self.window makeKeyAndVisible];
  return YES;
}

@end

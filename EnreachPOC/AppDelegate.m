//
//  AppDelegate.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 27/06/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "AppDelegate.h"
#import "Enreach.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
  
  NSDictionary* property = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @".mtv.fi", NSHTTPCookieDomain,
                            @"evid_0002", NSHTTPCookieName,
                            @"2b58b182-7808-46cb-8b01-0cc444a15b15", NSHTTPCookieValue,
                            @"/", NSHTTPCookiePath,
                            @"0", NSHTTPCookieVersion,
                            [[NSDate date] dateByAddingTimeInterval:31556916], NSHTTPCookieExpires,
                            nil];
  
  NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:property];
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
  
  property = [[NSDictionary alloc] initWithObjectsAndKeys:
              @".mtv.fi", NSHTTPCookieDomain,
              @"evid_0002-synced", NSHTTPCookieName,
              @"true", NSHTTPCookieValue,
              @"/", NSHTTPCookiePath,
              @"0", NSHTTPCookieVersion,
              [[NSDate date] dateByAddingTimeInterval:31556916], NSHTTPCookieExpires,
              nil];
  cookie = [[NSHTTPCookie alloc] initWithProperties:property];
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
  
  [Enreach sharedEnreachInstance];
  
  
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

//
//  ViewController.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 27/06/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "ViewController.h"
#import "EnreachSDK/Enreach.h"
#import "EnreachSDK/CampaignResponse.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)getUserPressed:(id)sender {
  NSLog(@"Number of Cookies: %lu",[[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]count]);
  [[Enreach sharedInstance] getUserEvid];
}
- (IBAction)getCampaignsPressed:(id)sender {
  NSLog(@"Number of Cookies: %lu",[[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]count]);
  
  void (^blockToRuleThemAll)(CampaignResponse*) = ^(CampaignResponse* response){
    NSLog(@"%@", [response evId]);
    NSLog(@"Here you go Boy! You use them blocks");
  };
  
  [[Enreach sharedInstance] getCampaignsWithBlock:blockToRuleThemAll];
  
  NSLog(@"Check campResponse");
  
}

- (IBAction)validatePressed:(id)sender {
  NSLog(@"Number of Cookies: %lu",[[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]count]);
}

- (IBAction)clearCookies:(id)sender {
  [[Enreach sharedInstance] clearEvid];
  for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
  }
}

@end

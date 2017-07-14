//
//  WebViewController.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 04/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

NSString* webPage = @"http://www.katsomo.fi";
//NSString* webPage = @"http://code3.adtlgc.com/js/test/mtv/ooyala_test_page.html";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadKatsomo:(id)sender {
  [self.webViewForKatsomo loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webPage]]];
}


@end

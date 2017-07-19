//
//  Enreach.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 28/06/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "Enreach.h"


#define EMPTYEVID @"-entered"

@implementation Enreach

@synthesize evid;

+(Enreach *)sharedInstanceWithParameters:(NSDictionary*) parameters {
  static Enreach *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once (&onceToken, ^{
    sharedInstance = [[self alloc] initWithParameters: parameters];
  });
  return sharedInstance;
}

-(id) initWithParameters:(NSDictionary*) parameters {
  if (self = [super init]) {
    evid = EMPTYEVID;
    self.paths = [[EnreachPaths alloc] initWithDomain:[parameters objectForKey:@"domain"] Paths:parameters AdServerId:[parameters objectForKey:@"adServerId"] AdmpApiVersion:[parameters objectForKey:@"admpApiVersion"]];
    [self getUserEvid];
    
    NSLog(@"Boop with parameters");
  }
  return self;
}

+(Enreach *)sharedInstance {
  static Enreach *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once (&onceToken, ^{
    //sharedInstance = [[self alloc] init];
    sharedInstance = [Enreach sharedInstanceWithParameters:[NSDictionary new]];
  });
  return sharedInstance;
}

-(void)getUserEvid {
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"evId"] != nil) {
    self.evid = [[NSUserDefaults standardUserDefaults] objectForKey:@"evId"];
  }
  else {
    NSURL *getUserURL = [NSURL URLWithString:[self.paths getUser]];
    NSURLRequest *request = [NSURLRequest requestWithURL:getUserURL];
  
    NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      [self handleGetUserWithData:data Response:response Error:error];
    }];
  
    [dataTask resume];
  }
}

-(void)handleValidateWithData:(NSData*)data Response:(NSURLResponse*)response Error:(NSError*)error {
  if (error == nil && [(NSHTTPURLResponse*)response statusCode] == 200 ) {
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data != nil) {
      NSError* error = nil;
      id object = [NSJSONSerialization JSONObjectWithData:[[Enreach stripNativeMethodName:responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
      if([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary* responseDictionary = (NSDictionary*) object;
        NSLog(@"%@", responseDictionary);
        if ([responseDictionary objectForKey:@"evId"] != nil) {
          if([self.evid isEqualToString:EMPTYEVID] && ![[responseDictionary objectForKey:@"evId"] isEqualToString:EMPTYEVID]) {
            self.evid = [responseDictionary objectForKey:@"evId"];
            [[NSUserDefaults standardUserDefaults] setObject:self.evid forKey:@"evId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
          }
        }
      }
    }
  }
  else {
    NSLog(@"Problem with accessing validate API");
  }
}

-(void)handleGetCampaignsWithData:(NSData*)data Response:(NSURLResponse*)response Error:(NSError*)error {
  if (error == nil && [(NSHTTPURLResponse*)response statusCode] == 200 ) {
    NSURL *validateURL = [NSURL URLWithString:[self.paths validate:[[NSDictionary alloc] initWithObjectsAndKeys:self.evid, @"evid", nil]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:validateURL];
    NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      [self handleValidateWithData:data Response:response Error:error];
    }];
    [dataTask resume];
  }
  else {
    NSLog(@"Problem with accessing getCampaigns API");
  }
}

-(void)handleGetUserWithData:(NSData*)data Response:(NSURLResponse*)response Error:(NSError*)error {
  if (error == nil && [(NSHTTPURLResponse*)response statusCode] == 200 ) {
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![responseString containsString:EMPTYEVID]) {
      NSError* error = nil;
      id object = [NSJSONSerialization JSONObjectWithData:[[Enreach stripNativeMethodName:responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
      if([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary* responseDictionary = (NSDictionary*) object;
        NSLog(@"%@", responseDictionary);
        if ([responseDictionary objectForKey:@"evId"] != nil) {
          self.evid = [responseDictionary objectForKey:@"evId"];
          [[NSUserDefaults standardUserDefaults] setObject:self.evid forKey:@"evId"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
          NSLog(@"Structure of the response has changed");
        }
      }
    }
    else {
      //call for getCampaigns and validate
      NSURL *getCampaignsURL = [NSURL URLWithString:[self.paths getCampaigns:[[NSDictionary alloc] initWithObjectsAndKeys:self.evid, @"evid", @"true", @"includeSegments", nil]]];
      NSURLRequest *request = [NSURLRequest requestWithURL:getCampaignsURL];
      NSURLSessionTask* sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handleGetCampaignsWithData:data Response:response Error:error];
      }];
      [sessionTask resume];
    }
  }
  else {
    NSLog(@"Problem with accessing getUser API");
  }
}

-(bool)isValidEvid {
  NSError *error = nil;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-f0-9]{8}(-[a-f0-9]{4}){3}-[a-f0-9]{12}" options:0 error:&error];
  NSInteger numberOfMatches = [regex numberOfMatchesInString:self.evid options:0 range:NSMakeRange(0, [self.evid length])];
  return (numberOfMatches > 0);
}

-(bool)isEmptyEvid {
  return [evid isEqualToString:EMPTYEVID];
}

-(void) clearEvid {
  self.evid = EMPTYEVID;
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"evId"];
}

-(void) callGetUser {
  NSURL *getUserURL = [NSURL URLWithString:[self.paths getUser]];
  
  NSURLRequest* request = [NSURLRequest requestWithURL:getUserURL];
  
  NSURLSession* sharedSession = [NSURLSession sharedSession];
  
  NSURLSessionDataTask* dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  }];

  [dataTask resume];
}

-(void) callGetCampaigns {
  NSURL *getCampaignsURL = [NSURL URLWithString:[self.paths getCampaigns:[[NSDictionary alloc] initWithObjectsAndKeys:self.evid, @"evid", @"true", @"includeSegments", nil]]];
  
  NSURLRequest* request = [NSURLRequest requestWithURL:getCampaignsURL];
  
  NSURLSession* sharedSession = [NSURLSession sharedSession];
  
  NSURLSessionDataTask* dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  }];
  
  [dataTask resume];
}

-(void) callValidate {
  NSURL *validateURL = [NSURL URLWithString:[self.paths validate:[[NSDictionary alloc] initWithObjectsAndKeys:self.evid, @"evid", nil]]];
  
  NSURLRequest* request = [NSURLRequest requestWithURL:validateURL];
  
  NSURLSession* sharedSession = [NSURLSession sharedSession];
  
  NSURLSessionDataTask* dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  }];
  
  [dataTask resume];
}

+(NSString*) stripNativeMethodName:(NSString*) response {
  
  if ([response containsString:@"native"]) {
    NSInteger startLoc = [response rangeOfString:@"("].location;
    NSInteger endLoc = [response rangeOfString:@")" options:NSBackwardsSearch].location;
    return([response substringWithRange:NSMakeRange(startLoc+1, endLoc-startLoc-1)]);
    
  }
  return(@"");
}

-(NSString*)getEvid {
  return self.evid;
}

-(void) getCampaignsWithBlock:(void (^)(CampaignResponse*)) blockToRuleThemAll {
  NSURL *getCampaignsURL = [NSURL URLWithString:[self.paths getCampaigns:[[NSDictionary alloc] initWithObjectsAndKeys:self.evid, @"evid", @"true", @"includeSegments", nil]]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:getCampaignsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    CampaignResponse* campResp = [[CampaignResponse alloc] initWithJSON:jsonString];
    if (blockToRuleThemAll != nil) {
      blockToRuleThemAll(campResp);
    }
  }];
  
  [dataTask resume];
}

-(CampaignResponse*) syncGetCampaigns {
  
  NSURL *getCampaignsURL = [NSURL URLWithString:[self.paths getCampaigns:[[NSDictionary alloc] initWithObjectsAndKeys:self.evid, @"evid", @"true", @"includeSegments", nil]]];
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:getCampaignsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    self.responseData = [[NSData alloc] initWithData:data];
    dispatch_semaphore_signal(semaphore);
  }];
  
  [dataTask resume];
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  return [[CampaignResponse alloc] initWithJSON:[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]];
}

-(void) setVisitorIdWithProvider:(NSString*)visitorProvider Id:(NSString*) visitorId {
  
  NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              visitorProvider, @"source",
                              visitorId, @"id",
                              self.evid, @"evid",
                              nil];
  
  NSURL *registerURL = [NSURL URLWithString:[self.paths registerURLString:parameters]];
  
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:registerURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"Registration to Provider %@ with ID %@ is over", visitorProvider, visitorId);
  }];
  
  [dataTask resume];
}

+(NSDictionary*) getParameters:(NSString*)evid Location:(NSString*)location Action:(NSString*)action AdInfo:(AdInfo*)adInfo {
  NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                          location, @"location",
                          evid, @"evid",
                          action, @"action",
                          [adInfo getAdId], @"adId",
                          [adInfo getBnId], @"bnId",
                          [adInfo getPId], @"pId",
                          nil];
  return result;
}

-(void) pageStatWithLocation:(NSString*)location {
  
  NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              location, @"location",
                              self.evid, @"evid",
                              nil];
  
  NSURL * pageStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:pageStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"PageStat request to location %@ is over", location);
  }];
  
  [dataTask resume];
}

-(void)placementStatWithLocation:(NSString*)location Ids:(NSArray*)ids {
  
  [self placementStatWithSource:@"id" Location:location Ids:ids];
}

-(void) placementStatWithSource:(NSString*)source Location:(NSString*)location Ids:(NSArray*)ids {
  NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              location, @"location",
                              self.evid, @"evid",
                              source, @"source",
                              [ids componentsJoinedByString:@","], @"values",
                              nil];
  NSURL *placementStatURL = [NSURL URLWithString:[self.paths placementStat:parameters]];
  
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:placementStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"placementStat request with locations %@ and Ids %@", location, [ids componentsJoinedByString:@","]);
  }];
  
  [dataTask resume];
}

-(void) arStatWithLocation:(NSString*) location {
  NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              location, @"location",
                              self.evid, @"evid",
                              nil];
  
  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ is over", location);
  }];
  
  [dataTask resume];
}

-(void) adDwellTime:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:DWELL] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and DWELL is over", location);
  }];
  
  [dataTask resume];
}

-(void) adClick:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:CLICK] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and CLICK is over", location);
  }];
  
  [dataTask resume];
}

-(void) adImpression:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:IMPRESSION] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and IMPRESSION is over", location);
  }];
  
  [dataTask resume];
}

-(void) videoStart:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:VIDEO_START] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and VIDEO_START is over", location);
  }];
  
  [dataTask resume];
}

-(void) videoFirstQuartile:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:VIDEO_FIRST_QUARTILE] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and VIDEO_FIRST_QUARTILE is over", location);
  }];
  
  [dataTask resume];
}

-(void) videoMidPoint:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:VIDEO_MIDPOINT] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and VIDEO_MIDPOINT is over", location);
  }];
  
  [dataTask resume];
}

-(void) videoThirdQuartile:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:VIDEO_THIRD_QUARTILE] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and VIDEO_THIRD_QUARTILE is over", location);
  }];
  
  [dataTask resume];
}

-(void) videoComplete:(NSString*)location AdInfo: (AdInfo*)adInfo {
  NSDictionary* parameters = [Enreach getParameters:self.evid Location:location Action:[AdStatState getType:VIDEO_COMPLETE] AdInfo:adInfo];

  NSURL * arStatURL = [NSURL URLWithString:[self.paths pageStat:parameters]];
  NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:arStatURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"arStat request to location %@ and VIDEO_COMPLETE is over", location);
  }];
  
  [dataTask resume];
}


@end

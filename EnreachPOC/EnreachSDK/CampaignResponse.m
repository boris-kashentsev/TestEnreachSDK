//
//  CampaignResponse.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 11/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "CampaignResponse.h"

@implementation CampaignResponse

-(bool)isReference {
  return self.reference;
}

-(NSString*) getEvId {
  return self.evId;
}

-(NSDictionary*) getCampaignIds {
  return self.campaignIds;
}

-(NSArray*) getSegments {
  return self.segments;
}

-(NSString*) getVv {
  return self.vv;
}

-(id)initWithJSON:(NSString*)jsonString {
  self = [super init];
  
  if(self != nil) {
    
    NSError *error = nil;
    NSString* cleanJson = [CampaignResponse stripNativeMethodName:jsonString];
    id object = [NSJSONSerialization JSONObjectWithData:[cleanJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error == nil && [object isKindOfClass:[NSDictionary class]]) {
      NSDictionary* campaigns = (NSDictionary*) object;
      if ([campaigns objectForKey:@"evId"] != nil) {
        self.evId = [campaigns objectForKey:@"evId"];
      }
      if ([campaigns objectForKey:@"vv"] != nil) {
        self.vv = [campaigns objectForKey:@"vv"];
      }
      if ([campaigns objectForKey:@"campaignIds"] != nil) {
        self.campaignIds = [campaigns objectForKey:@"campaignIds"];
      }
      if ([campaigns objectForKey:@"segments"] != nil) {
        self.segments = [campaigns objectForKey:@"segments"];
      }
      if ([campaigns objectForKey:@"reference"] != nil) {
        self.reference = [[campaigns objectForKey:@"reference"] boolValue];
      }
    }
    else {
      NSLog(@"There is a problem with a JSON of the getCampaign response");
      self = nil;
    }
  }
  
  return self;
}

+(NSString*) stripNativeMethodName:(NSString*) response {
  
  if ([response containsString:@"native"]) {
    NSInteger startLoc = [response rangeOfString:@"("].location;
    NSInteger endLoc = [response rangeOfString:@")" options:NSBackwardsSearch].location;
    return([response substringWithRange:NSMakeRange(startLoc+1, endLoc-startLoc-1)]);
    
  }
  return(@"");
}

@end

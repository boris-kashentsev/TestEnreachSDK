//
//  EnreachPaths.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 07/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "EnreachPaths.h"
#import "Constants.h"

@implementation EnreachPaths

-(id)initWithDomain:(NSString*)domain Paths:(NSDictionary*)paths AdServerId:(NSString*)adServerId AdmpApiVersion:(NSString*)admpApiVersion {
  self = [super init];
  
  self.domain = domain;
  if ([self.domain hasSuffix:@"/"]) {
    self.domain = [self.domain substringToIndex: [self.domain length]-1];
  }
  
  
  self.getUserPath = [paths objectForKey:@"getUserPath"] != nil ? [paths objectForKey:@"getUserPath"] : getUserPathConst;
  self.campaignsPath = [paths objectForKey:@"campaignsPath"] != nil ? [paths objectForKey:@"campaignsPath"] : campaignsPathConst;
  self.validatePath = [paths objectForKey:@"validatePath"] != nil ? [paths objectForKey:@"validatePath"] : validatePathConst;
  self.registerPath = [paths objectForKey:@"registerPath"] != nil ? [paths objectForKey:@"registerPath"] : registerPathConst;
  self.arStatPath = [paths objectForKey:@"arStatPath"] != nil ? [paths objectForKey:@"arStatPath"] : arStatPathConst;
  self.adStatPath = [paths objectForKey:@"adStatPath"] != nil ? [paths objectForKey:@"adStatPath"] : adStatPathConst;
  self.pageStatPath = [paths objectForKey:@"pageStatPath"] != nil ? [paths objectForKey:@"pageStatPath"] : pageStatPathConst;
  self.placementPath = [paths objectForKey:@"placementPath"] != nil ? [paths objectForKey:@"placementPath"] : placementPathConst;
  
  self.adServerId = adServerId != nil ? adServerId : @"";
  
  self.admpApiVersion = admpApiVersion != nil ? admpApiVersion : admpApiVersionConst;
  
  return self;
}

-(id)initWithDomain:(NSString*)domain Paths:(NSDictionary*)paths {
  self = [self initWithDomain:domain Paths:paths AdServerId:nil AdmpApiVersion:nil];
  
  return self;
}

-(id)initWithDomain:(NSString*)domain {
  self = [self initWithDomain:domain Paths:[[NSDictionary alloc] init]];
  
  return self;
}

-(NSString*) getUser {
  return [self getUser:[[NSDictionary alloc] init]];
}

-(NSString*) getUser:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.getUserPath Parameters:params RequiresAdServerId:false];
}

-(NSString*) getCampaigns:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.campaignsPath Parameters:params RequiresAdServerId:false];
}

-(NSString*) registerURLString:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.registerPath Parameters:params RequiresAdServerId:false];
}

-(NSString*) validate:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.validatePath Parameters:params RequiresAdServerId:false];
}

-(NSString*) pageStat:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.pageStatPath Parameters:params RequiresAdServerId:false];
}

-(NSString*) placementStat:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.placementPath Parameters:params RequiresAdServerId:true];
}

-(NSString*) adStat:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.adStatPath Parameters:params RequiresAdServerId:true];
}

-(NSString*) arStat:(NSDictionary*) params {
  return [self getFullUrlWithDomain:self.domain Path:self.arStatPath Parameters:params RequiresAdServerId:false];
}

-(NSString*) getAdServerId {
  return self.adServerId;
}

-(NSString*) getFullUrlWithDomain:(NSString*)domain Path:(NSString*)path Parameters:(NSDictionary*)parameters RequiresAdServerId:(BOOL)requiresAsServerId {
  if (domain == nil || [domain isEqualToString:@""]) {
    NSLog(@"ERROR: Domain is empty. Please, instanciate EnreachPaths class with domain.");
    return @"";
  }
  
  NSString* url = [[NSString alloc] initWithString:domain];
  url = [url stringByAppendingFormat:@"%@?",path];
  for(NSString* key in parameters) {
    url = [url stringByAppendingFormat:@"%@=%@&", [EnreachPaths encode:key], [EnreachPaths encode:[parameters objectForKey:key]]];
  }
  
  if(requiresAsServerId) {
    url = [url stringByAppendingFormat:@"adserverId=%@&", [EnreachPaths encode:self.adServerId]];
  }
  
  
  url = [url stringByAppendingFormat:@"cb=%@&",[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
  url = [url stringByAppendingFormat:@"callback=native&v=%@",self.admpApiVersion];
  
  return url;
}

+(NSString*) encode:(NSString*)s {
  NSString* result = [s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

  return result != nil ? result : @"";
}

@end

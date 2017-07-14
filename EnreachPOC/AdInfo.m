//
//  AdInfo.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 06/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "AdInfo.h"

@implementation AdInfo

- (id)initWithPlacementId:(NSString*)pId{
  self = [super init];
  if (self) {
    _pId = pId;
    _adId = @"";
    _bnId = @"";
  }
  return self;
}

-(id)initWithPlacementId:(NSString*)pId campaignId:(NSString*)adId creativeId:(NSString*)bnId{
  self = [super init];
  if (self) {
    _pId = pId;
    _adId = adId;
    _bnId = bnId;
  }
  return self;
}

-(NSString*)getPId {
  return _pId;
}

-(NSString*)getAdId {
  return _adId;
}

-(NSString*)getBnId {
  return _bnId;
}

@end

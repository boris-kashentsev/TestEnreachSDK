//
//  AdStatState.m
//  EnreachPOC
//
//  Created by Boris Kashentsev on 06/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import "AdStatState.h"

@implementation AdStatState

#define AdStatStateString(enum) [@[@"imp",@"click",@"dwellTime", @"start", @"midpoint", @"firstQuartile", @"thirdQuartile", @"complete"] objectAtIndex:enum]

+(NSString*)getType:(AdStatStateEnum) enumValue{
  return AdStatStateString(enumValue);
}

@end

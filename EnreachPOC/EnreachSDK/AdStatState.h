//
//  AdStatState.h
//  EnreachPOC
//
//  Created by Boris Kashentsev on 06/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdStatState : NSObject

typedef enum {
  IMPRESSION = 0,
  CLICK,
  DWELL,
  VIDEO_START,
  VIDEO_MIDPOINT,
  VIDEO_FIRST_QUARTILE,
  VIDEO_THIRD_QUARTILE,
  VIDEO_COMPLETE
} AdStatStateEnum;

+(NSString*)getType:(AdStatStateEnum) enumValue;

@end

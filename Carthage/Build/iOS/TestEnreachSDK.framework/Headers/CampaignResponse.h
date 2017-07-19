//
//  CampaignResponse.h
//  EnreachPOC
//
//  Created by Boris Kashentsev on 11/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CampaignResponse : NSObject

@property BOOL reference;
@property (nonatomic, strong) NSString *evId;
@property (nonatomic, strong) NSDictionary *campaignIds;
@property (nonatomic, strong) NSArray *segments;

@property (nonatomic, strong) NSString* vv;

-(id)initWithJSON:(NSString*)jsonString;

@end

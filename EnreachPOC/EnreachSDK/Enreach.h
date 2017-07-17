//
//  Enreach.h
//  EnreachPOC
//
//  Created by Boris Kashentsev on 28/06/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdInfo.h"
#import "AdStatState.h"
#import "EnreachPaths.h"
#import "CampaignResponse.h"

@interface Enreach : NSObject

@property (nonatomic, strong) NSString *evid;
@property (nonatomic, strong) NSData* responseData;
@property (nonatomic, strong) AdInfo* adInfo;
@property (nonatomic, strong) EnreachPaths* paths;

-(bool) isEmptyEvid;

+(Enreach *)sharedEnreachInstance;
-(void) callGetUser;
-(void) callValidate;
-(void) callGetCampaigns;

-(void)clearEvid;

-(void)setEvid:(NSString *)evid;
-(NSString*)getEvid;

-(void)getUserEvid;
-(void) getCampaignsWithBlock:(void (^)(CampaignResponse*)) block;
-(CampaignResponse*) syncGetCampaigns;
@end

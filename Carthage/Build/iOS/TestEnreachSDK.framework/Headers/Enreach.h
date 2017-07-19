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

+(Enreach *) sharedInstance;
+(Enreach *) sharedInstanceWithParameters:(NSDictionary*) parameters;

-(void) clearEvid;

-(void) setEvid:(NSString *)evid;
-(NSString*) getEvid;

-(void) getUserEvid;
-(void) getCampaignsWithBlock:(void (^)(CampaignResponse*)) block;
-(CampaignResponse*) syncGetCampaigns;
-(void) setVisitorIdWithProvider:(NSString*)visitorProvider Id:(NSString*) visitorId;
-(void) pageStatWithLocation:(NSString*)location;
-(void) placementStatWithLocation:(NSString*)location Ids:(NSArray*)ids;
-(void) placementStatWithSource:(NSString*)source Location:(NSString*)location Ids:(NSArray*)ids;
-(void) arStatWithLocation:(NSString*) location;

-(void) adDwellTime:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) adClick:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) adImpression:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) videoStart:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) videoFirstQuartile:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) videoMidPoint:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) videoThirdQuartile:(NSString*)location AdInfo: (AdInfo*)adInfo;
-(void) videoComplete:(NSString*)location AdInfo: (AdInfo*)adInfo;
@end

//
//  AdInfo.h
//  EnreachPOC
//
//  Created by Boris Kashentsev on 06/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdInfo : NSObject

@property (nonatomic, strong) NSString* pId;
@property (nonatomic, strong) NSString* adId;
@property (nonatomic, strong) NSString* bnId;

-(id)initWithPlacementId:(NSString*)pId;
-(id)initWithPlacementId:(NSString*)pId campaignId:(NSString*)adId creativeId:(NSString*)bnId;

-(NSString*) getPId;
-(NSString*) getAdId;
-(NSString*) getBnId;

@end

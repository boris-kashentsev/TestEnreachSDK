//
//  EnreachPaths.h
//  EnreachPOC
//
//  Created by Boris Kashentsev on 07/07/2017.
//  Copyright © 2017 Boris Kashentsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnreachPaths : NSObject

@property (nonatomic, strong) NSString* domain;

@property (nonatomic, strong) NSString* getUserPath;
@property (nonatomic, strong) NSString* campaignsPath;
@property (nonatomic, strong) NSString* validatePath;
@property (nonatomic, strong) NSString* registerPath;
@property (nonatomic, strong) NSString* arStatPath;
@property (nonatomic, strong) NSString* adStatPath;
@property (nonatomic, strong) NSString* pageStatPath;
@property (nonatomic, strong) NSString* placementPath;

@property (nonatomic, strong) NSString* adServerId;
@property (nonatomic, strong) NSString* admpApiVersion;

-(id)initWithDomain:(NSString*)domain;
-(id)initWithDomain:(NSString*)domain Paths:(NSDictionary*)paths;
-(id)initWithDomain:(NSString*)domain Paths:(NSDictionary*)paths AdServerId:(NSString*)adServerId AdmpApiVersion:(NSString*)admpApiVersion;

-(NSString*) getUser;
-(NSString*) getUser:(NSDictionary*) params;
-(NSString*) getCampaigns:(NSDictionary*) params;
-(NSString*) registerURLString:(NSDictionary*) params;
-(NSString*) validate:(NSDictionary*) params;
-(NSString*) pageStat:(NSDictionary*) params;
-(NSString*) placementStat:(NSDictionary*) params;
-(NSString*) adStat:(NSDictionary*) params;
-(NSString*) arStat:(NSDictionary*) params;

@end

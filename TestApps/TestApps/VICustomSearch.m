//
//  VICustomSearch.m
//  TestApps
//
//  Created by я on 12.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "VICustomSearch.h"

@implementation VICustomSearch
{
    NSString* apiKey;
    NSString* searchEngineID;
    NSString* fullString;
    NSString* bundleID;
}

- (id)init {
    self = [super init];
    if (self) {
        bundleID = @"com.VolkovIS.TestApps";
        apiKey = @"AIzaSyAUtILGhrW0pLqpuROI9jLsAo6a9H8K9hA";
        searchEngineID = @"015442153918896918168:rqwfyitfm9w";
    }
    return self;
}

- (NSDictionary*)getJSONwithRequest:(NSString *)requestText {
    
    fullString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@", requestText, searchEngineID, apiKey];
    
    NSURL* url = [NSURL URLWithString:[fullString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request setValue:bundleID forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
    
    NSError* requestError;
    NSData* d = [NSData dataWithContentsOfURL:url];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:&requestError];

    return json;
}

@end

//
//  TableDataDelegate.m
//  TestApps
//
//  Created by я on 08.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "VITableDataDelegate.h"

@implementation VITableDataDelegate

- (NSMutableArray*)getItemElementsArray:(NSString*)stringKey {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:description];
    [request setResultType:NSDictionaryResultType];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&requestError];
    if (requestError)
    {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    _elementsArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *object in resultArray)
    {
        [_elementsArray addObject:[object valueForKey:stringKey]];
    }
    
    return _elementsArray;
}

@end

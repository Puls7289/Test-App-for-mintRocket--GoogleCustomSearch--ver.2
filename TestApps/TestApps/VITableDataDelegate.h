//
//  TableDataDelegate.h
//  TestApps
//
//  Created by я on 08.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "AppDelegate.h"

@interface VITableDataDelegate : AppDelegate

@property (strong, nonatomic) NSMutableArray* elementsArray;

- (NSMutableArray*)getItemElementsArray:(NSString*)stringKey;

@end

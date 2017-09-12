//
//  VIImagesLoaded.h
//  TestApps
//
//  Created by я on 12.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VIImagesLoaded : NSObject

- (void)getImageUrlFrom:(NSDictionary*)jsonDictionary andPlaceImageToUI:(UIImageView*)ui;

@end

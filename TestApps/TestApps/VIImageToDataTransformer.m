//
//  ImageToDataTransformer.m
//  TestApps
//
//  Created by я on 10.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "VIImageToDataTransformer.h"

@interface VIImageToDataTransformer ()

@end

@implementation VIImageToDataTransformer

+ (void)registerValueTransformer {
    [NSValueTransformer setValueTransformer:[[self alloc] init] forName:@"BPImageTransformer"];
}

#pragma mark -
#pragma mark NSValueTransformer implementation

+ (BOOL)allowsReverseTransformation {
    return YES;
}
+ (Class)transformedValueClass {
    return [NSData class];
}

#pragma mark -
#pragma mark Image transformation

- (id)transformedValue:(id)value {
    if (value == nil)
        return nil;
    
    // I pass in raw data when generating the image, save that directly to the database
    if ([value isKindOfClass:[NSData class]])
        return value;
    
    return UIImageJPEGRepresentation((UIImage *)value, 1.0);
}

- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:(NSData *)value];
}

@end

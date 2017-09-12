//
//  VIImagesLoaded.m
//  TestApps
//
//  Created by я on 12.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "VIImagesLoaded.h"

@implementation VIImagesLoaded
{
    NSString* firstImageUrl;
    UIImageView* imageView;
}

- (void)getImageUrlFrom:(NSDictionary*)jsonDictionary andPlaceImageToUI:(UIImageView*)ui {
    
    imageView = ui;
    if (jsonDictionary != nil)
    {
        if (jsonDictionary.allValues.count > 0)
        {
            NSArray* array = [jsonDictionary valueForKeyPath:@"items.pagemap.imageobject.url"];
            if (array)
            {
                NSArray* array2 = [array objectAtIndex:0];
                if (array2)
                {
                    firstImageUrl = [array2 objectAtIndex:0];
                }
            }
        }
    }
    [self loadImage:[NSURL URLWithString:firstImageUrl]];
}

- (void)loadImage:(NSURL *)imageURL
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(requestRemoteImage:)
                                        object:imageURL];
    [queue addOperation:operation];
}

- (void)requestRemoteImage:(NSURL *)imageURL
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(placeImageInUI:) withObject:image waitUntilDone:YES];
}

- (void)placeImageInUI:(UIImage *)image
{
    [imageView setImage:image];
}

@end

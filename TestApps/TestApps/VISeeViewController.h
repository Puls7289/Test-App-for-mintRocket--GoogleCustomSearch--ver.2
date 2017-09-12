//
//  SeeViewController.h
//  TestApps
//
//  Created by я on 08.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VISeeViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *itemNameLabel;
@property (strong, nonatomic) NSString *itemName;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionField;
@property (strong, nonatomic) NSString *itemDescription;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) UIImage *itemImage;

@end

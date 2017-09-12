//
//  TableViewCell.m
//  TestApps
//
//  Created by я on 08.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize itemName = _itemName;
@synthesize itemDescription = _itemDescription;
@synthesize itemImage = _itemImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

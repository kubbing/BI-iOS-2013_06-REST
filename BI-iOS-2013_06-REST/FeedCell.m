//
//  FeedCell.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.detailTextLabel.numberOfLines = 2;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGFloat kImageSize = 80;
    self.imageView.frame = CGRectMake(8,
                                      (CGRectGetHeight(self.contentView.bounds) - kImageSize)/2.0,
                                      kImageSize,
                                      kImageSize);
    
    self.textLabel.frame = CGRectMake(8+kImageSize+8, 8, CGRectGetWidth(self.contentView.bounds) - 8 - kImageSize - 8, CGRectGetHeight(self.contentView.bounds)/2.0 - 8);
    self.detailTextLabel.frame = CGRectMake(8+kImageSize+8, CGRectGetHeight(self.contentView.bounds)/2.0, CGRectGetWidth(self.contentView.bounds) - 8 - kImageSize - 8, CGRectGetHeight(self.contentView.bounds)/2.0 - 8);
}

@end

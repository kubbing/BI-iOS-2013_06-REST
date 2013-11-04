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
        UIImageView *thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
        thumbView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:thumbView];
        {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[thumbView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thumbView)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[thumbView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thumbView)]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:thumbView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:thumbView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        }
        self.thumbView = thumbView;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:nameLabel];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:messageLabel];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    const CGFloat kImageSize = 80;
//    self.imageView.frame = CGRectMake(8,
//                                      (CGRectGetHeight(self.contentView.bounds) - kImageSize)/2.0,
//                                      kImageSize,
//                                      kImageSize);
//    
//    self.textLabel.frame = CGRectMake(8+kImageSize+8, 8, CGRectGetWidth(self.contentView.bounds) - 8 - kImageSize - 8, CGRectGetHeight(self.contentView.bounds)/2.0 - 8);
//    self.detailTextLabel.frame = CGRectMake(8+kImageSize+8, CGRectGetHeight(self.contentView.bounds)/2.0, CGRectGetWidth(self.contentView.bounds) - 8 - kImageSize - 8, CGRectGetHeight(self.contentView.bounds)/2.0 - 8);
//}

@end

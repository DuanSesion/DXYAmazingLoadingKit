//
//  JigsawCell.m
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawListCell.h"
#import "JigsawList.h"

@interface JigsawListCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIImageView *lockImageView;

@end

@implementation JigsawListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma makr - init
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        CGFloat WH = self.frame.size.width;
        imageView.frame = CGRectMake(0.f, 0.f, WH, WH);
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        UIImageView *lockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resourse.bundle/jiesaw_unlock_icon"]];
        [lockImageView sizeToFit];
        lockImageView.center = self.contentView.center;
        [self.contentView addSubview:lockImageView];
        _lockImageView = lockImageView;
    }
    return _lockImageView;
}

- (void)setup {
    self.imageView.hidden = NO;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 5.f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)setModel:(JigsawList *)model {
    _model = model;
    self.imageView.image = model.image;
    self.lockImageView.hidden = model.unClock;
}

@end

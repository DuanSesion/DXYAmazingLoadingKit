//
//  JigsawGameCell.m
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawGameCell.h"

@interface JigsawGameCell ()

@end

@implementation JigsawGameCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.borderWidth = 2.f;
    
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        self.layer.borderColor = [UIColor colorWithRed:1.f green:0.9647f blue:0.f alpha:1.f].CGColor;
        
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end

//
//  JigsawCollectionReusableView.m
//  XDGame
//
//  Created by imac on 2018/3/27.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawCollectionReusableView.h"

@interface JigsawCollectionReusableView ()

@property (nonatomic, weak) UIButton *starButton;

@end

@implementation JigsawCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (UIButton *)starButton {
    if (!_starButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 10.f;
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_star_button_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_star_button_hilight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat buttonY = 15.f;
        CGFloat buttonW = self.frame.size.width - 46.f;
        CGFloat buttonH = 55.f;
        
        button.frame = CGRectMake(23.f,  buttonY, buttonW, buttonH);
        [self addSubview:button];
        _starButton = button;
    }
    return _starButton;
}

- (void)setup {
    self.starButton.hidden = NO;
    
}

- (void)buttonAction:(id)sender {
    if (_jigsawBlock) {
        _jigsawBlock();
    }
}

@end

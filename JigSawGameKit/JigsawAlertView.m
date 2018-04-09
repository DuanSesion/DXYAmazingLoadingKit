//
//  JigsawAlertView.m
//  XDGame
//
//  Created by imac on 2018/3/28.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawAlertView.h"

@interface JigsawAlertView ()

@property (nonatomic, weak) UIImageView *menuImageView;
@property (nonatomic, weak) UILabel *content_label;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, copy) void(^block)(void);

@end

@implementation JigsawAlertView

+ (void)jigsawAlertViewShowWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlignment compled:(void (^)(void))block {
    JigsawAlertView *alert = [[JigsawAlertView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    alert.block = block;
    alert.content_label.text = title;
    
    if (title.length) {
        CGFloat content_label_X = 20.f;
        CGFloat content_label_Y = 30.f;
        CGFloat content_label_W = CGRectGetWidth(alert.menuImageView.frame) - 2 * 10.f;
        
        CGSize content_labelSize = [alert sizeWithText:title font:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake(content_label_W, MAXFLOAT)];
        CGFloat content_label_H = content_labelSize.height;
    
        alert.content_label.frame = CGRectMake(content_label_X, content_label_Y, content_label_W, content_label_H);
        [alert.content_label sizeToFit];
        
        CGRect aFrame = alert.content_label.frame;
        aFrame.size.width = content_label_W;
        alert.content_label.frame = aFrame;
     
        
        CGFloat mHeight = CGRectGetMaxY(alert.content_label.frame) + 50.f;
        CGRect rect = alert.menuImageView.frame;
        rect.size.height = mHeight;
        alert.menuImageView.frame = rect;
    }
    
    alert.content_label.textAlignment = textAlignment;
    alert.menuImageView.center = alert.center;
    alert.button.center = CGPointMake(CGRectGetMidX(alert.frame), CGRectGetMaxY(alert.menuImageView.frame));
    
    [UIView animateWithDuration:3.f animations:^{
        [alert animationWithAlertView];
    }];
}

- (void)animationWithAlertView {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.menuImageView.layer addAnimation:animation forKey:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    [super setFrame:frame];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (UIImageView *)menuImageView {
    if (!_menuImageView) {
        UIImageView *menuImageView = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"resourse.bundle/ji_alert_background_icon"]];
        menuImageView.clipsToBounds = YES;
        [menuImageView sizeToFit];
        
        CGRect rect = menuImageView.frame;
        rect.size.width = CGRectGetWidth(self.frame) - 40.f;
        menuImageView.frame = rect;
        
        [self addSubview:menuImageView];
        _menuImageView = menuImageView;
    }
    return _menuImageView;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 10.f;
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/ji_alert_button_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/ji_alert_button_hilight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat buttonY = 15.f;
        CGFloat buttonW = self.frame.size.width - 46.f;
        CGFloat buttonH = 55.f;
        
        button.frame = CGRectMake(23.f,  buttonY, buttonW, buttonH);
        [self addSubview:button];
        _button = button;
    }
    return _button;
}

- (void)buttonAction:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        if (self.block) {
            self.block();
        }
        [self removeFromSuperview];
    }];
}

- (void)setup {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f];
    
    // 提示内容
    UILabel *content_label = [[UILabel alloc] init];
    content_label.numberOfLines = 0;
    content_label.font = [UIFont boldSystemFontOfSize:14.5];
    content_label.textColor = [UIColor blackColor];
    [self.menuImageView addSubview:content_label];
    _content_label = content_label;
}

@end

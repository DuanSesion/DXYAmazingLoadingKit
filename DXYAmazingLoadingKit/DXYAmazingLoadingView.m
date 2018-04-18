//
//  XDAmazingLoadingView.m
//  Loading
//
//  Created by Duanshaoxiong on 2017/9/7.
//  Copyright © 2017年 duanshaoxiong. All rights reserved.
//

#import "DXYAmazingLoadingView.h"

static const CGFloat kAmazingSize = 40.f;
static const CGFloat kTimeInterval = 1.5f;

@interface DXYAmazingLoadingView () <CAAnimationDelegate>

@end

@implementation DXYAmazingLoadingView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size = CGSizeMake(kAmazingSize, kAmazingSize);
    [super setFrame:frame];
}

- (void)setup {
    self.backgroundTintColor = [UIColor colorWithRed:75.f/255 green:102.f/255 blue:234.f/255 alpha:1];
    [self startAnimating];
}

- (void)setBackgroundColor:(UIColor *)color {
    [super setBackgroundColor:[UIColor clearColor]];
}

- (CALayer *)bubbleWithTimingFunction:(CAMediaTimingFunction *)timingFunction initialScale:(CGFloat)initialScale finalScale:(CGFloat)finalScale tintColor:(UIColor *)tintColor atLayer:(CALayer *)layer {
    CALayer *bubbleLayer = [CALayer layer];
    bubbleLayer.frame = CGRectMake(0.f, 0.f, 6.f, 6.f);
    bubbleLayer.cornerRadius = CGRectGetMidX(bubbleLayer.frame);
    bubbleLayer.masksToBounds = YES;
    bubbleLayer.backgroundColor = self.backgroundTintColor.CGColor;
    [layer addSublayer:bubbleLayer];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = kTimeInterval;
    pathAnimation.repeatCount = CGFLOAT_MAX;
    pathAnimation.autoreverses = NO;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.timingFunction = timingFunction;
    pathAnimation.path = [UIBezierPath bezierPathWithArcCenter:CGPointZero
                                                        radius:kAmazingSize / 2.8
                                                    startAngle:3 * M_PI / 2
                                                      endAngle:3 * M_PI / 2 + 2 * M_PI
                                                     clockwise:YES].CGPath;
    
    [bubbleLayer addAnimation:pathAnimation forKey:nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = kTimeInterval;
    scaleAnimation.repeatCount = CGFLOAT_MAX;
    scaleAnimation.fromValue = @(initialScale);
    scaleAnimation.toValue = @(finalScale);
    scaleAnimation.delegate = self;
    
    if(initialScale > finalScale) {
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else {
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    [bubbleLayer addAnimation:scaleAnimation forKey:nil];
    
    return bubbleLayer;
}

#pragma mark - # CAAnimationDelegate
- (void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag {
   
}

#pragma mark - pravite method
- (void)setupNormalState {
    self.layer.speed = 1.0f;
    self.layer.opacity = 1.0;
}

- (void)setupFadeOutState {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.layer.sublayers = nil;
    self.layer.speed = 0.0;
}

#pragma mark - public method
- (void)startAnimating {
    [self setupNormalState];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    for (NSUInteger i = 0; i < 5; i++) {
        CGFloat x = i * (1.0f / 5);
        [self bubbleWithTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.5f :(0.1f + x) :0.25f :1.0f]
                          initialScale:1.0f - x
                            finalScale:0.2f + x
                             tintColor:self.backgroundTintColor
                               atLayer:self.layer];
    }
}

- (void)stopAnimating {
    [self setupFadeOutState];
    [self removeFromSuperview];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

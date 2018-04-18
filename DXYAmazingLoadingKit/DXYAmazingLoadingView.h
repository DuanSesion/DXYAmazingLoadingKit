//
//  XDAmazingLoadingView.h
//  Loading
//
//  Created by Duanshaoxiong on 2017/9/7.
//  Copyright © 2017年 duanshaoxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXYAmazingLoadingView : UIView

@property (nonatomic, strong) UIColor *backgroundTintColor;
@property (nonatomic, strong) UIColor *loadingTintColor;

- (void)startAnimating;
- (void)stopAnimating;

@end

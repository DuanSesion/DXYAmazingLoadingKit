//
//  JigsawGame.h
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JigsawGame : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, assign) BOOL selected;

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage *)image;

@end

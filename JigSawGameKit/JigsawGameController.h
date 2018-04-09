//
//  JigsawGameController.h
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JigsawList;

@interface JigsawGameController : UIViewController

@property (nonatomic, assign) JigsawList *model;
@property (nonatomic, copy) void(^gameBlock)(void);

@end

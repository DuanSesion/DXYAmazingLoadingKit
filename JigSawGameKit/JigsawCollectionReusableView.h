//
//  JigsawCollectionReusableView.h
//  XDGame
//
//  Created by imac on 2018/3/27.
//  Copyright © 2018年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JigsawCollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) void(^jigsawBlock)(void);

@end

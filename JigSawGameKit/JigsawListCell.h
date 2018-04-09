//
//  JigsawCell.h
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JigsawList;

@interface JigsawListCell : UICollectionViewCell

//@property (nonatomic, assign) UIImage *image;
//@property (nonatomic, assign) BOOL unClock;

@property (nonatomic, strong) JigsawList *model;

@end

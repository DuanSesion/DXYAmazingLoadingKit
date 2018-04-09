//
//  JigsawAlertView.h
//  XDGame
//
//  Created by imac on 2018/3/28.
//  Copyright © 2018年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JigsawAlertView : UIView

+ (void)jigsawAlertViewShowWithTitle:(NSString *)title
                       textAlignment:(NSTextAlignment)textAlignment
                             compled:(void (^)(void))block;

@end

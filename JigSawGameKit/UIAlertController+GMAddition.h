//
//  UIAlertController+XDAddition.h
//  SpringTalkStaff
//
//  Created by Duanshaoxiong on 2017/3/28.
//  Copyright © 2017年 Chengdu TangDaDa Technolog Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (GMAddition)

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                        actionWithCancel:(NSString *)cancel
                             otherAction:(NSString *)otherButtonTitles
                                  cancel:(void(^)(UIAlertAction * action))cancelBlock
                                   other:(void(^)(UIAlertAction * action))otherBlock;

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                        actionWithCancel:(NSString *)cancel
                                  cancel:(void(^)(UIAlertAction * action))cancelBlock;

@end

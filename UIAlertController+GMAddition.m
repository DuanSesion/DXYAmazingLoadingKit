//
//  UIAlertController+XDAddition.m
//  SpringTalkStaff
//
//  Created by Duanshaoxiong on 2017/3/28.
//  Copyright © 2017年 Chengdu TangDaDa Technolog Co. Ltd. All rights reserved.
//

#import "UIAlertController+GMAddition.h"

@implementation UIAlertController (GMAddition)

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                        actionWithCancel:(NSString *)cancel
                             otherAction:(NSString *)otherButtonTitles
                                  cancel:(void(^)(UIAlertAction * _Nonnull action))cancelBlock
                                  other:(void(^)(UIAlertAction * _Nonnull action))otherBlock {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message
                                                             preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:(UIAlertActionStyleCancel)
                                                         handler:cancelBlock];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:otherButtonTitles
                                                       style:(UIAlertActionStyleDefault)
                                                     handler:otherBlock];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    return alert;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                        actionWithCancel:(NSString *)cancel
                                  cancel:(void(^)(UIAlertAction * _Nonnull action))cancelBlock {
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title message:message
                                                             preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:(UIAlertActionStyleCancel)
                                                         handler:cancelBlock];
    [alert addAction:cancelAction];
    return alert;
}

@end

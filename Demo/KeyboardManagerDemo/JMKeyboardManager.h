//
//  JMKeyboardManager.h
//  ControlTest
//
//  Created by print on 2018/9/27.
//  Copyright © 2018年 liuxuanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JMKeyboardManager : NSObject

/// 全局开启关闭
@property (nonatomic, assign) BOOL enable;
/// 键盘Toolbar
@property (nonatomic, assign) BOOL enableAutoToolbar;
/// 自定义toolbar
@property (nonatomic, strong) UIToolbar *toolbar;


/// 单例初始化方法
+ (JMKeyboardManager *)shareManager;

/// textField和要上移的视图绑定
+ (void)bindingTextField:(UIView *)textField moveView:(UIView *)moveView;


@end

NS_ASSUME_NONNULL_END

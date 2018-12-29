//
//  JMKeyboardManager.m
//  ControlTest
//
//  Created by print on 2018/9/27.
//  Copyright © 2018年 liuxuanbo. All rights reserved.
//

#import "JMKeyboardManager.h"
#import <objc/runtime.h>


static const void *MoveViewKey = &MoveViewKey;
static const void *MoveViewOriginYKey = &MoveViewOriginYKey;

@interface JMKeyboardManager ()

@property (nonatomic, assign) CGFloat keyboardHeight;   // 键盘高度

@property (nonatomic, strong) UIView *textFieldView;    // 输入框或文本域

@property (nonatomic, strong) NSMutableArray<UIView *> *moveViewQueue;  // 上移的视图队列

@end

@implementation JMKeyboardManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (JMKeyboardManager *)shareManager {
    static JMKeyboardManager *manager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        self.moveViewQueue = [NSMutableArray array];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self beginMoveUpView];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self recoverMoveUpView];   // 恢复上移视图
}

- (void)keyboardDidHide:(NSNotification *)notification {
    // 键盘收回恢复所有变量
    self.textFieldView = nil;
    self.keyboardHeight = 0;
    [self.moveViewQueue removeAllObjects];
}

// textField会先执行textFieldViewDidBeginEditing方法, 后执行keyboardWillShow方法, textView相反
- (void)textFieldViewDidBeginEditing:(NSNotification*)notification {
    self.textFieldView = notification.object;   // 获取激活的输入框
    [self beginMoveUpView];
    [self toolbarSetting]; // 设置是否显示toolbar

}

// 开始上移视图
- (void)beginMoveUpView {
    if (!self.enable) {
        return;
    }
    if (self.textFieldView && self.keyboardHeight > 0) {
        UIView *moveView = objc_getAssociatedObject(self.textFieldView, MoveViewKey);
        if (moveView) {
            CGFloat textFieldBottom = [self.textFieldView convertPoint:CGPointMake(CGRectGetMinX(self.textFieldView.frame), CGRectGetHeight(self.textFieldView.frame)) toView:[[UIApplication sharedApplication].delegate window]].y;
            textFieldBottom = fmin(textFieldBottom, [UIScreen mainScreen].bounds.size.height); // 输入框底部相对window的高度
            CGFloat moveHeight = textFieldBottom + self.keyboardHeight - [UIScreen mainScreen].bounds.size.height; // 键盘遮挡的距离
            if (moveHeight > 0) {
                if (![self.moveViewQueue containsObject:moveView]) { // 将视图放到队列中
                    objc_setAssociatedObject(moveView, MoveViewOriginYKey, @(moveView.frame.origin.y), OBJC_ASSOCIATION_RETAIN_NONATOMIC); // 记录最初的坐标y
                    [self.moveViewQueue addObject: moveView];
                }
                [UIView animateWithDuration:0.26 animations:^{
                    moveView.frame = CGRectMake(moveView.frame.origin.x, moveView.frame.origin.y - moveHeight, moveView.frame.size.width, moveView.frame.size.height);
                }];
            }
        }
    }
}

// 恢复所有上移视图的位置
- (void)recoverMoveUpView {
    if (self.moveViewQueue.count > 0) {
        for (UIView *moveView in self.moveViewQueue) {
            CGFloat y = [objc_getAssociatedObject(moveView, MoveViewOriginYKey) floatValue]; // 获得原始坐标y
            moveView.frame = CGRectMake(moveView.frame.origin.x, y, moveView.frame.size.width, moveView.frame.size.height);
        }
    }
}

// 将输入框和要上移的视图绑定
+ (void)bindingTextField:(UIView *)textField moveView:(UIView *)moveView {
    if (textField && moveView) {
        // 此输入框激活时, 若键盘遮挡输入框, 则上移moveView
        objc_setAssociatedObject(textField, MoveViewKey, moveView, OBJC_ASSOCIATION_ASSIGN);
    }
}

// 设置是否显示toolbar
- (void)toolbarSetting {
    if (!self.textFieldView) {
        return;
    }
    if ([self.textFieldView isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self.textFieldView;
        textField.inputAccessoryView = self.enableAutoToolbar ? self.toolbar : nil;
    } else {
        UITextView *textView = (UITextView *)self.textFieldView;
        textView.inputAccessoryView = self.enableAutoToolbar ? self.toolbar : nil;
        [textView reloadInputViews];
    }
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
        doneBarButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *nilButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _toolbar.items = @[nilButton, doneBarButton];
    }
    return _toolbar;
}

- (void)doneButtonAction:(UIButton *)sender {
    [[[UIApplication sharedApplication].delegate window] endEditing:YES];
}


@end

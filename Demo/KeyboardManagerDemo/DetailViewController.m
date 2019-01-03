//
//  DetailViewController.m
//  KeyboardManagerDemo
//
//  Created by print on 2018/12/28.
//  Copyright © 2018年 liuxuanbo. All rights reserved.
//

#import "DetailViewController.h"
#import "JMKeyboardManager.h"
@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [JMKeyboardManager shareManager].enable = YES;
    [JMKeyboardManager shareManager].enableAutoToolbar = YES;
    [self createUI];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)createUI {
    if (![self.title isEqualToString:@"UITableView"]) {
        
    }

    if ([self.title isEqualToString:@"UITextField"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 350, 150, 40)];
        label.text = @"self.view上移";
        [self.view addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 500, 200, 40)];
        textField.text = @"  输入框";
        textField.layer.borderColor = [UIColor grayColor].CGColor;
        textField.layer.borderWidth = 0.5;
        [self.view addSubview:textField];
        [JMKeyboardManager bindingTextField:textField moveView:self.view];
    } else if ([self.title isEqualToString:@"UITextView"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 350, 150, 40)];
        label.text = @"self.view上移";
        [self.view addSubview:label];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 500, 200, 80)];
        textView.text = @"  文本域";
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.layer.borderWidth = 0.5;
        [self.view addSubview:textView];
        [JMKeyboardManager bindingTextField:textView moveView:self.view];
    } else if ([self.title isEqualToString:@"UITableView"]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
    } else if ([self.title isEqualToString:@"OtherView"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 150, 40)];
        label.text = @"backView上移";
        [self.view addSubview:label];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(50, 450, 300, 140)];
        backView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:backView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 200, 40)];
        textField.text = @"  输入框";
        textField.layer.borderColor = [UIColor blackColor].CGColor;
        textField.layer.borderWidth = 0.5;
        [backView addSubview:textField];
        [JMKeyboardManager bindingTextField:textField moveView:backView];
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell.contentView.subviews.count) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 200, 40)];
        textField.delegate = self;
        textField.text = @"  输入框";
        textField.font = [UIFont systemFontOfSize:15];
        textField.layer.borderColor = [UIColor grayColor].CGColor;
        textField.layer.borderWidth = 0.5;
        [cell.contentView addSubview:textField];
        [JMKeyboardManager bindingTextField:textField moveView:self.view];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

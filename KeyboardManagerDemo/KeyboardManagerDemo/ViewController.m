//
//  ViewController.m
//  KeyboardManagerDemo
//
//  Created by print on 2018/12/28.
//  Copyright © 2018年 liuxuanbo. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *datasources;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"键盘弹出视图上移Demo";
    datasources = @[@"UITextField", @"UITextView", @"UITableView", @"OtherView"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datasources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = datasources[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.title = datasources[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end

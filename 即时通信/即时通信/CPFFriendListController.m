//
//  CPFFriendListController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

/**
 *  @author 崔鹏飞, 2016-05-20 20:46:59
 
 #import "FriendListViewController.h"
 #import "AddFriendViewController.h"
 #import "ChatViewController.h"
 #import <EaseMob.h>
 @interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,EMChatManagerBuddyDelegate>
 @property(nonatomic, strong)NSMutableArray *listArray;
 @property(nonatomic, strong)UITableView *tableView;
 @end
 
 @implementation FriendListViewController
 
 -(void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 
 }
 -(void)loadView
 {
 [super loadView];
 self.view.backgroundColor = [UIColor whiteColor];
 //左侧注销按钮
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelButton)];
 self.title = @"好友";
 
 [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
 
 if (!error) {
 NSLog(@"获取成功 -- %@", buddyList);
 
 [_listArray removeAllObjects];
 [_listArray addObjectsFromArray:buddyList];
 [_tableView reloadData];
 }
 } onQueue:dispatch_get_main_queue()];
 
 }
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 _listArray = [NSMutableArray new];
 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addbuttonAction)];
 _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
 _tableView.delegate = self;
 _tableView.dataSource = self;
 _tableView.tableFooterView = [[UIView alloc]init];
 [self.view addSubview:_tableView];
 //签协议
 [ [EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
 }
 
 -(void)didClickedCancelButton
 {
 //注销用户
 [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
 [self.navigationController popViewControllerAnimated:YES];
 }
 
 -(void)addbuttonAction
 {
 [self.navigationController pushViewController:[[AddFriendViewController alloc]init] animated:YES];
 }
 
 # pragma mark - Table View Data Source
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
 return _listArray.count;
 }
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 50;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *identifier = @"cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
 if (!cell) {
 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
 }
 
 EMBuddy * buddy = _listArray[indexPath.row];
 
 cell.textLabel.text = buddy.username;
 
 return cell;
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 ChatViewController * chatVC = [[ChatViewController alloc]init];
 
 EMBuddy * buddy = _listArray[indexPath.row];
 
 chatVC.name = buddy.username;
 
 [self.navigationController pushViewController:chatVC animated:YES];
 }
 -(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
 {
 UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的请求", username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
 UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *  action) {
 EMError * error;
 // 同意好友请求的方法
 if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
 NSLog(@"发送同意成功");
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
 
 if (!error) {
 NSLog(@"获取成功 -- %@", buddyList);
 
 [_listArray removeAllObjects];
 [_listArray addObjectsFromArray:buddyList];
 [_tableView reloadData];
 }
 } onQueue:dispatch_get_main_queue()];
 });
 }
 }];
 UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"滚" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
 EMError * error;
 // 拒绝好友请求的方法
 if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"滚, 快滚!" error:&error] && !error) {
 NSLog(@"发送拒绝成功");
 }
 }];
 [alertController addAction:acceptAction];
 [alertController addAction:rejectAction];
 [self showDetailViewController:alertController sender:nil];
 }
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 */

#import "CPFFriendListController.h"
#import "EaseMob.h"
#import "TKAlertCenter.h"

@interface CPFFriendListController () <EMChatManagerDelegate>

@property (nonatomic, strong) NSArray *friendList;

@end

@implementation CPFFriendListController

- (void)viewWillAppear:(BOOL)animated{
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    _friendList = [NSMutableArray array];
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            _friendList = buddyList;
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"获取好友列表失败"];
        }
    } onQueue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _friendList = [NSArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _friendList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    EMBuddy *buddy = _friendList[indexPath.row];
    cell.textLabel.text = buddy.username;
    return cell;
}


#pragma mark - EMChatManagerBuddyDelegate

- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd {
    _friendList = buddyList;
    [self.tableView reloadData];
}

- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error {
    if (!error) {
        _friendList = buddyList;
        NSLog(@"didFetchedBuddyList成功 ----%@",_friendList);
        [self.tableView reloadData];
    }else{
        NSLog(@"didFetchedBuddyList失败 ----%@",_friendList);
    }
}

@end

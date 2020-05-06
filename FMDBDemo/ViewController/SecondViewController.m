//
//  SecondViewController.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/10.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "SecondViewController.h"
#import "Constant.h"
#import "ChatRecordTableViewCell.h"

#import <FMDB/FMDB.h>
#import "MessageModel.h"
#import "ChatViewController.h"

#import "Contact.h"
#import "SearchResultViewController.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>

@property(strong,nonatomic) UISearchController *searchController;
@property(strong,nonatomic) UITableView *tableView;

//数据源
@property(strong,nonatomic) NSMutableArray *dataList;

@property(strong,nonatomic) NSMutableArray *searchList;


@property(nonatomic,strong) FMDatabase *db;

@property(strong,nonatomic) NSMutableArray *queryList;
@end

@implementation SecondViewController


//- (UISearchController *)searchController
//{
//    if (!_searchController) {
//        _searchController = [[UISearchController alloc]init];
//    }
//    return _searchController;
//}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"消息";
    _dataList = [[NSMutableArray alloc]init];
    _searchList = [[NSMutableArray alloc]init];
    
    
    _queryList = [[NSMutableArray alloc]init];
    
    [self executeFMDB];
    [self getData];
    
    [self setController];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"ReloadData" object:nil];


}

-(void)reloadData
{
    NSLog(@"CJLJLJLJLJL");
    
    [_dataList removeAllObjects];
    
    [self getData];
    
    [self.tableView reloadData];
}

-(void)setController{
    self.tableView.frame =CGRectMake(0, 0, ScreenWidth, ScreenHight);
  //  self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater =self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES; // 这是push成功的关键
    [self.view addSubview:self.tableView];
    


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.searchList count];
    }
    else{
        return [self.dataList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ChatRecord";
    ChatRecordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.messageModel = _dataList[indexPath.row];
    cell.textLabel.text= cell.messageModel.sender;
    cell.detailTextLabel.text = cell.messageModel.messageText;
    cell.imageView.image = [UIImage imageNamed:@"man"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.rightLabel.text = cell.messageModel.messageTime;
    [cell.rightLabel setFont:[UIFont systemFontOfSize:15]];
    cell.rightLabel.textColor = [UIColor grayColor];
    [cell.rightLabel sizeToFit];
    cell.rightLabel.frame = CGRectMake(ScreenWidth-cell.rightLabel.frame.size.width-8, 20, cell.rightLabel.frame.size.width, cell.rightLabel.frame.size.height);
//    //少用这种方法
//    UILabel *label  = [[UILabel alloc]init];
//  //  label.font = cell.detailTextLabel.font;
//    label.font = [UIFont systemFontOfSize:12];
//    label.textColor = [UIColor blackColor];
//    [label sizeToFit];
//
//    label.text = @"20:30";
//    label.textAlignment =NSTextAlignmentRight;
//    label.frame = CGRectMake(ScreenWidth - label.frame.size.width-15, 7, label.frame.size.width, label.frame.size.height);
//    label.backgroundColor = [UIColor yellowColor];
//    cell.rightLabel = label;

    
    
    
//    UISwitch * myswitch = [[UISwitch alloc]init];
//    cell.accessoryView = myswitch;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
    //  ChatTableViewController *chatTableViewController = [[ChatTableViewController alloc]init];
    //  chatTableViewController.hidesBottomBarWhenPushed = YES; 在storyboard中可以t勾选
    chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"22"];
    
    ChatRecordTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    chatViewController.title =cell.textLabel.text;
    chatViewController.talkerID = cell.messageModel.ID;
    
    [[self navigationController]pushViewController:chatViewController animated:YES];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
      NSString *keyword = searchController.searchBar.text;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", keyword];
    NSArray *fliter = [_queryList filteredArrayUsingPredicate:predicate];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"record CONTAINS[c] %@", keyword];
    NSArray *fliter2 = [_queryList filteredArrayUsingPredicate:predicate2];
    
    NSLog(@"CCCC::::%ld",fliter2.count);
    NSLog(@"CCCC111::::%ld",fliter.count);
    
    
    SearchResultViewController *resultVC = (SearchResultViewController*)searchController.searchResultsController;
    
    resultVC.resultArray = fliter;
    
    resultVC.resultArrayRecord = fliter2;
    
    [resultVC.tableView reloadData];
}

-(void) executeFMDB{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"contact.sqlite"];
    NSLog(@"path = %@",path);
    
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {
        
        NSLog(@"success to open data base");
        
        
    }
    else{
        NSLog(@"fail to open database");
    }
    self.db=db;
    
}

-(void)getData{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"select t_student.id,t_student.name,t_message.messagetime,t_message.messagetext, MAX(t_message.id) FROM t_message left join t_student on t_message.talker = t_student.id GROUP BY t_student.id"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        
        MessageModel *model = [[MessageModel alloc]init];
        model.showMessageTime = YES;
        model.sender = [resultSet stringForColumn:@"name"];
        model.messageTime = [resultSet stringForColumn:@"messagetime"];
        model.messageText = [resultSet stringForColumn:@"messagetext"];
        model.ID = [resultSet intForColumn:@"id"];
        
        [_dataList addObject:model];
    }
        NSLog(@"曹佳龙000：%ld",_dataList.count);
    
    FMResultSet *result = [self.db executeQuery:@"select t_student.id,t_student.name,t_message.messagetext FROM t_message left join t_student on t_message.talker = t_student.id"];
    
    while ([result next]) {
        
        Contact *model = [[Contact alloc]init];
        model.ID = [result intForColumn:@"id"];
        model.name = [result stringForColumn:@"name"];
        model.record = [result stringForColumn:@"messagetext"];
        
        [_queryList addObject:model];
    }
    NSLog(@"曹佳龙：%ld",_queryList.count);
}

@end

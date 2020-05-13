//
//  FirstViewController.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/10.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "FirstViewController.h"
#import <FMDB/FMDB.h>
#import "Contact.h"
#import "CommonMethods.h"
#import "ChatViewController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>


@property (copy, nonatomic) NSArray *keys;   //索引字母数组
@property (copy, nonatomic) NSDictionary *dict; //存放数据的字典
@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic, strong)UITableView *tableView;
@property(strong,nonatomic) UISearchController *searchController;
@property(strong,nonatomic) NSMutableArray *dataList; //存放待查找数据的数组

@end

@implementation FirstViewController{
    
    NSMutableArray *filteredNames;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

   self.title = @"通讯录";
    
    UIBarButtonItem* add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAddData)];
    self.navigationItem.rightBarButtonItem = add;
    
    UITableView * tableView = [self.view viewWithTag:1];
    self.tableView = tableView;
    
//    UIEdgeInsets contentInset = self.tableView.contentInset;
//    contentInset.top = 20;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
    
    //数组的初始化
    filteredNames = [NSMutableArray array];
    
    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater= self;
    
    self.tableView.tableHeaderView=self.searchController.searchBar;
    

    [self executeSql];
    [self getData];
}

-(void)pressAddData{
//       [self delete];
         [self insert];
//         [self query];
    [self getData];
    [self.tableView reloadData];
    
}

//插入数据
 -(void)insert
 {
                 NSString *name = [CommonMethods generateTradeNO];
                 // executeUpdate : 不确定的参数用?来占位
                    //整型数字 要用@()
                 [self.db executeUpdate:@"INSERT INTO t_student (name, sex) VALUES (?, ?);", name, @(arc4random_uniform(2))];
     
                 // executeUpdateWithFormat : 不确定的参数用%@、%d等来占位
                 //        [self.db executeUpdateWithFormat:@"INSERT INTO t_student (name, age) VALUES (%@, %d);", name, arc4random_uniform(40)];
}
 //删除数据
 -(void)delete
 {
        //    [self.db executeUpdate:@"DELETE FROM t_student;"];
         [self.db executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, sex integer NOT NULL);"];
}

 //查询
 - (void)query
 {
         // 1.执行查询语句
         FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    
        // 2.遍历结果
         while ([resultSet next]) {
                 int ID = [resultSet intForColumn:@"id"];
                 NSString *name = [resultSet stringForColumn:@"name"];
                 int sex = [resultSet intForColumn:@"sex"];
                 NSLog(@"%d %@ %d", ID, name, sex);
             }
     }


//初始化数据
-(void)getData{
    
    _dataList = [[NSMutableArray alloc]init];
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    
    NSMutableArray *keyArray =[[NSMutableArray alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        int sex = [resultSet intForColumn:@"sex"];
        
        Contact *contact = [[Contact alloc]init];
        contact.name = name;
        contact.sex = sex;
        contact.ID = ID;
        
    //    NSLog(@"%d %@ %d", ID, name, sex);
        
        [_dataList addObject:contact];
        
        //首字母为key value为contact对象组成的数组  
        NSString *firstAsKey =[CommonMethods firstCharactorWithString:name];
        if ([keyArray count] == 0 ||![keyArray containsObject:firstAsKey] ) {
            [keyArray addObject:firstAsKey];  //不存在首字母的key就放进数组用于判断
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:contact];
            [dic setValue:array forKey:firstAsKey];  //value : 包含模型数据的数组。 key:首字母
        }
        else{
            NSMutableArray *array = [dic valueForKey:firstAsKey];
            [array addObject:contact];
            [dic removeObjectForKey:firstAsKey];
            [dic setObject:array forKey:firstAsKey];
        }
    }

    self.dict = [NSDictionary dictionaryWithDictionary:dic];
    NSLog(@"%lu",[self.dict count]);
    
    /*输出看看
    NSArray *keys = [self.dict allKeys];
     
    for (int i = 0; i<self.dict.count; i++)
    {
        NSString *key = keys[i];
        
        NSMutableArray *array = self.dict[key];
        for (Contact *contact in array) {
            NSLog(@"%@", contact.name);
        }
    }
     */
    
    //把首字母按字母表排序
    self.keys = [[self.dict allKeys] sortedArrayUsingSelector:
                 @selector(compare:)];

     NSLog(@"CJL::::%ld",_dataList.count);
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (self.searchController.active) {
        return 1;
    }
    else
    {
        return [self.keys count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [filteredNames count];
    }
    else
    {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.dict[key];
        return [nameSection count];
    }

}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
       return nil;
    }
    else
    {
         return self.keys[section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    
    if (self.searchController.active) {
        Contact *contact = [[Contact alloc]init];
        contact = filteredNames[indexPath.row];
        cell.textLabel.text = contact.name;
    }
    else
    {
        NSString *key = self.keys[indexPath.section];
        NSArray *nameSection = self.dict[key];
        Contact *contact = [[Contact alloc]init];
        contact =nameSection[indexPath.row];
        cell.textLabel.text = contact.name;
        cell.tag =contact.ID;
        

        
        if (contact.sex == 1) {
            cell.imageView.image = [UIImage imageNamed:@"man"];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"women"];
        }
    }
    
    return cell;
    
}


 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (self.searchController.active) {
        return 0.01;
    }
    else
    {
        return 15;
    }
    return 0;
}

//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return nil;
    } else {
        return self.keys;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
//  chatTableViewController.hidesBottomBarWhenPushed = YES; 在storyboard中可以t勾选
    chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"22"];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    chatViewController.title =cell.textLabel.text;
    chatViewController.talkerID = cell.tag;
   
    [[self navigationController]pushViewController:chatViewController animated:YES];
}


#pragma mark - Search Display Delegate Methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSLog(@"---updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchString];
    if (filteredNames!= nil) {
        [filteredNames removeAllObjects];
    }
    //过滤数据
    filteredNames = [NSMutableArray arrayWithArray: [_dataList filteredArrayUsingPredicate:predicate]];
    //刷新表格
    [self.tableView reloadData];
}


#pragma mark - FMDB
-(void) executeSql{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"contact.sqlite"];
    NSLog(@"path = %@",path);
    
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {

        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, sex integer NOT NULL)";
        [db executeUpdate:createTableSqlString];
    }
    else{
        NSLog(@"fail to open database");
        }
    self.db=db;
    
}


@end


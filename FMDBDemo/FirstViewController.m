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
#import "ChatTableViewController.h"
#import "ChatViewController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface FirstViewController ()


@property (copy, nonatomic) NSArray *keys;
@property (copy, nonatomic) NSDictionary *dict;
@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic, strong)UITableView *tableView;

@end

@implementation FirstViewController{
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   self.title = @"通讯录";
    
    UIBarButtonItem* add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAddData)];
    self.navigationItem.rightBarButtonItem = add;
    
    UITableView * tableView = [self.view viewWithTag:1];
    self.tableView = tableView;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    
//    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
//    self.keys = [[self.names allKeys] sortedArrayUsingSelector:
//                 @selector(compare:)];
    
    filteredNames = [NSMutableArray array];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.placeholder = @"想要找什么吗";
    tableView.tableHeaderView = searchBar;
    
    searchController = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    
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
                 [self.db executeUpdate:@"INSERT INTO t_student (name, sex) VALUES (?, ?);", name, @(arc4random_uniform(2))];
                 //        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);" withArgumentsInArray:@[name, @(arc4random_uniform(40))]];
        
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

        NSLog(@"%d %@ %d", ID, name, sex);

        
        NSString *firstAsKey =[CommonMethods firstCharactorWithString:name];
        if ([keyArray count] == 0 ||![keyArray containsObject:firstAsKey] ) {
            [keyArray addObject:firstAsKey];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:contact];
            [dic setValue:array forKey:firstAsKey];
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
    NSArray *keys = [self.dict allKeys];
    
    for (int i = 0; i<self.dict.count; i++)
    {
        NSString *key = keys[i];
        
        NSMutableArray *array = self.dict[key];
        for (Contact *contact in array) {
            NSLog(@"%@", contact.name);
        }
    }
    self.keys = [[self.dict allKeys] sortedArrayUsingSelector:
                 @selector(compare:)];

}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return [self.keys count];
    } else {
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.dict[key];
        return [nameSection count];
    } else {
        return [filteredNames count];
    }

}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.keys[section];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    
    if (tableView.tag == 1) {
        NSString *key = self.keys[indexPath.section];
        NSArray *nameSection = self.dict[key];
        Contact *contact = [[Contact alloc]init];
        contact =nameSection[indexPath.row];
        cell.textLabel.text = contact.name;
        if (contact.sex == 1) {
                        cell.imageView.image = [UIImage imageNamed:@"man"];
                    }
                    else{
                        cell.imageView.image = [UIImage imageNamed:@"women"];
                    }
    } else {
        cell.textLabel.text = filteredNames[indexPath.row];
    }

    return cell;
}


 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return self.keys;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
//  ChatTableViewController *chatTableViewController = [[ChatTableViewController alloc]init];
//  chatTableViewController.hidesBottomBarWhenPushed = YES; 在storyboard中可以t勾选
    chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"22"];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    chatViewController.title =cell.textLabel.text;

   
    [[self navigationController]pushViewController:chatViewController animated:YES];
}


#pragma mark - Search Display Delegate Methods
- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:SectionsTableIdentifier];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredNames removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate =
        [NSPredicate predicateWithBlock:^BOOL(NSString *name, NSDictionary *b) {
             NSRange range = [name rangeOfString:searchString
                                         options:NSCaseInsensitiveSearch];
             return range.location != NSNotFound;
         }];
        for (NSString *key in self.keys) {
//            NSArray *matches = [self.names[key]
//                                filteredArrayUsingPredicate: predicate];
            NSArray *matches = [self.dict[key]
                                filteredArrayUsingPredicate: predicate];
            [filteredNames addObjectsFromArray:matches];
        }
    }
    return YES;
}

#pragma mark - FMDB
-(void) executeSql{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"contact.sqlite"];
    NSLog(@"path = %@",path);
    
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {
        //性别这里只能为0和1 待改
//        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS T_contact(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL  sex integer NOT NULL)";
        
        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, sex integer NOT NULL)";
        [db executeUpdate:createTableSqlString];
        
        
    }
    else{
        NSLog(@"fail to open database");
    }
    self.db=db;
    
}


@end


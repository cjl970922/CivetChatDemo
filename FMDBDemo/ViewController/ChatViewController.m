//
//  ChatViewController.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "Constant.h"
#import <FMDB/FMDB.h>
#import "CommonMethods.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@property(nonatomic,strong) FMDatabase *db;


//@property (nonatomic,strong) NSMutableArray *dataArrayOfRecord;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    [self executeFMDB];

    [self getData];
   // [self query];
    
//    MessageModel *model = [[MessageModel alloc]init];
//    model.showMessageTime = YES;
//    model.messageTime = @"2020年1月23日  12:11";
//    model.messageSenderType = 1;
//    model.messageType = 1;
//    model.messageText = @"如果你觉得今天很惨，没事，别伤心，因为明天会更惨，但你不会措手不及。";
//
//    [_dataArray addObject:model];
//
//
//    model = [[MessageModel alloc]init];
//    model.showMessageTime = YES;
//    model.messageTime = @"2020年1月23日  12:18";
//    model.messageSenderType = MessageSenderTypeOther;
//    model.messageType = MessageTypeText;
//    model.messageText = @"是啊！真的英雄主义，就是在看清了生活的真相之后，还依然热爱它";
//    [_dataArray addObject:model];

//    model = [[MessageModel alloc] init];
//    model.showMessageTime=YES;
//    model.messageSenderType = MessageSenderTypeMe;
//    model.messageType = MessageTypeImage;
//    model.imageSmall = [UIImage imageNamed:@"w"];
//    model.messageTime = @"16:40";
//    [_dataArray addObject:model];
//
//    model = [[MessageModel alloc] init];
//    model.showMessageTime=YES;
//    model.messageSenderType = MessageSenderTypeOther;
//    model.messageType = MessageTypeImage;
//    model.imageSmall = [UIImage imageNamed:@"mm"];
//    model.messageTime = @"16:40";
//    [_dataArray addObject:model];
//
//
//    model = [[MessageModel alloc] init];
//    model.showMessageTime = YES;
//    model.messageTime = @"2020年1月23日  12:11";
//    model.messageSenderType = MessageSenderTypeMe;
//    model.messageType = MessageTypeText;
//    model.messageText = @"如果你觉得今天很惨，没事，别伤心，因为明天会更惨，但你不会措手不及。";
//    [_dataArray addObject:model];
//

    
    _tableView.separatorColor = [UIColor clearColor];
  //  _tableView.backgroundColor = [UIColor redColor];
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
//    [self insert];
}


-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _constraint.constant = 0-height;

}

-(void)KeyboardWillHide:(NSNotification *)aNotification
{
     _constraint.constant = 0;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        [self.textView resignFirstResponder];
        if (textView.text.length == 0)
        {
            return NO;
        }
        MessageModel *model = [[MessageModel alloc] init];
        model.showMessageTime=YES;
//        model.messageSenderType = MessageSenderTypeMe;
//        model.messageType = MessageTypeText;
        model.messageSenderType = 1;
        model.messageType = 1;
        model.messageText = textView.text;
        model.messageTime = [CommonMethods getCurrentTime];
        [_dataArray addObject:model];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
//                                    animated:YES
//                              scrollPosition:UITableViewScrollPositionMiddle];
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        textView.text = @"";
        
        
        if ([self.db executeUpdate:@"INSERT INTO t_message (messagetype,messagesendertype,messagetime,messagetext,talker) VALUES (1, 1,'2020年5月20日 22:20',?,?);", model.messageText,@(self.talkerID)]) {
            
             NSLog(@"插入数据成功");
        }
        else
        {
            NSLog(@"插入数据失败");
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadData" object:nil];

        return NO;
    }

    return YES;
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell=[MessageCell cellWithTableView:tableView messageModel:_dataArray[indexPath.row]];
    //cell.delegate = self;
    cell.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = _dataArray[indexPath.row];
    return [model cellHeight];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - FMDB
-(void) executeFMDB{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"contact.sqlite"];
    NSLog(@"path = %@",path);
    
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {

        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_message (id integer PRIMARY KEY AUTOINCREMENT, messagetype integer NOT NULL, messagesendertype integer NOT NULL,messagetime TEXT NOT NULL, messagetext TEXT NOT NULL,talker integer NOT NULL)";
        [db executeUpdate:createTableSqlString];
        
        
    }
    else{
        NSLog(@"fail to open database");
    }
    self.db=db;
    
}


-(void)getData{
    NSLog(@"结束：%ld",self.talkerID);
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_message WHERE talker = ?", @(self.talkerID)];

    // 2.遍历结果
    while ([resultSet next]) {

        MessageModel *model = [[MessageModel alloc]init];
        model.showMessageTime = YES;
        model.messageTime = [resultSet stringForColumn:@"messagetime"];
        model.messageSenderType = [resultSet intForColumn:@"messagesendertype"];
        model.messageType = [resultSet intForColumn:@"messagetype"];
        model.messageText = [resultSet stringForColumn:@"messagetext"];
        
        [_dataArray addObject:model];
    }
}

//查询
// if ([self.db executeUpdate:@"INSERT INTO t_message (messagetype,messagesendertype,messagetime,messagetext,talker) VALUES (1, 1,'2020年5月20日 22:20',?,2);", model.messageText]) {
//- (void)query
//{
//    NSInteger  inteager = 2;
//    // 1.执行查询语句
//    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_message WHERE talker = ?",@(inteager)];
//
//    // 2.遍历结果
//    while ([resultSet next]) {
//        // int ID = [resultSet intForColumn:@"id"];
//        NSString *name = [resultSet stringForColumn:@"messagetext"];
//        // int sex = [resultSet intForColumn:@"sex"];
//        NSLog(@"曹佳龙：%@",name);
//
//    }
//}
//插入数据
-(void)insert
{

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_message(messagetype,messagesendertype,messagetime,messagetext,talker) VALUES(1,1,'2020年1月23日 12:11','我爱你',1);"];
    if ([self.db executeUpdate:sql]) {
        NSLog(@"插入数据成功");
    }
    else
    {
        NSLog(@"插入数据失败");
    }
    
}
//删除数据
-(void)delete
{
    //    [self.db executeUpdate:@"DELETE FROM t_student;"];
    [self.db executeUpdate:@"DROP TABLE IF EXISTS t_message;"];
    NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_message (id integer PRIMARY KEY AUTOINCREMENT, messagetype integer NOT NULL, messagesendertype integer NOT NULL,messagetime TEXT NOT NULL, messagetext TEXT NOT NULL,talker integer NOT NULL)";
    [self.db executeUpdate:createTableSqlString];
}

//查询
//- (void)query
//{
//    // 1.执行查询语句
//    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
//
//    // 2.遍历结果
//    while ([resultSet next]) {
//        int ID = [resultSet intForColumn:@"id"];
//        NSString *name = [resultSet stringForColumn:@"name"];
//        int sex = [resultSet intForColumn:@"sex"];
//        NSLog(@"%d %@ %d", ID, name, sex);
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

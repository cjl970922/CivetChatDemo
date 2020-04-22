//
//  ChatTableViewController.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "ChatTableViewController.h"

@interface ChatTableViewController ()<UITextViewDelegate>

@property (nonatomic, assign) CGFloat nowHeight;

@end

@implementation ChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
    
    _nowHeight =  self.tableView.frame.size.height;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self bottemView];
}

-(void)bottemView
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.hidden = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44)];
    bgView.tag = 100;
    bgView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = [[UIColor alloc] initWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1].CGColor;
    bgView.layer.borderWidth = 1;
  //  [self.view addSubview:bgView];
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(49, self.view.bounds.size.height-44, self.view.bounds.size.width - 152, 44)];
    textView.delegate = self;
    textView.tag = 101;
    textView.returnKeyType = UIReturnKeySend;
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textView.text = @"hello world";
    [bgView addSubview:textView];
    
    NSArray *arrayBtns = [NSArray arrayWithObjects:bgView, nil];
    self.toolbarItems = arrayBtns;
}

- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

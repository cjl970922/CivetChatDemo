//
//  ChatRecordTableViewCell.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/24.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "ChatRecordTableViewCell.h"



@implementation ChatRecordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    {
        if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
            
            _rightLabel = [[UILabel alloc]init];
            [self.contentView addSubview:_rightLabel];

        }
        return self;
    }
}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end

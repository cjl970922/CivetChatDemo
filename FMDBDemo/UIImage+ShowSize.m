//
//  UIImage+ShowSize.m
//  FMDBDemo
//
//  Created by Civet on 2020/4/18.
//  Copyright © 2020年 icivet. All rights reserved.
//

#import "UIImage+ShowSize.h"
#define MAX_IMAGE_W 141.0
#define MAX_IMAGE_H 228.0
@implementation UIImage (ShowSize)



//判断图片长度&宽度

-(CGSize)imageShowSize{
    
    CGFloat imageWith=self.size.width;
    CGFloat imageHeight=self.size.height;
    
    
    //宽度大于高度
    if (imageWith >= imageHeight) {
        // 宽度超过标准宽度
        /**/
        if (imageWith > MAX_IMAGE_W)
        {
            return CGSizeMake(MAX_IMAGE_W, imageHeight*MAX_IMAGE_W/imageWith);
        }
        else
        {
            return self.size;
        }
    }
    else
    {
        /**/
        if (imageHeight > MAX_IMAGE_H)
        {
            return CGSizeMake(imageWith*MAX_IMAGE_W/imageHeight, MAX_IMAGE_W);
        }
        else
        {
            return self.size;
        }
    }
    
    
    
    
    
    return CGSizeZero;
}
@end

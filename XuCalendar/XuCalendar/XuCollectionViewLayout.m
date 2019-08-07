//
//  XuCollectionViewLayout.m
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import "XuCollectionViewLayout.h"

@interface XuCollectionViewLayout()

@property (strong,  nonatomic) NSMutableArray *attributesArray;

@end

@implementation XuCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.attributesArray = @[].mutableCopy;
    if (self.pageWidth == 0) {
        self.pageWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}

// 计算每个item的frame
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger index = indexPath.item;
    
    NSInteger page = index / (self.row * self.column);
    
    // % 运算 确定 x 是 0,1,2 ... self.column-1
    CGFloat x = index % self.column * (self.itemSize.width + self.minimumInteritemSpacing) + page * self.pageWidth;
    // / 运算 确定 y 是 在哪行(一行有 column 个)， % 确定在 0,1,2 ... self.row-1 行内的哪行
    CGFloat y = (index / self.column % self.row) * (self.itemSize.height + self.minimumLineSpacing);
    
    attribute.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    return attribute;
}

// 返回所有item的frame
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

// 返回总的可见尺寸，避免一页未排满，滑动显示不全
- (CGSize)collectionViewContentSize {
    CGFloat width = (self.attributesArray.count/(self.row * self.column)) * self.pageWidth;
    return CGSizeMake(width, 0);
}

@end

//
//  SPActionSheetDefaultItem.m
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import "SPActionSheetDefaultItem.h"
#import "SPActionSheetData.h"
#import <Masonry/Masonry.h>


@interface SPActionSheetDefaultItem ()

//titleLabel
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation SPActionSheetDefaultItem


- (void)setupView{
    [super setupView];
    //rand color
    self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:.8];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
    }];
}

- (void)setData:(SPActionSheetData *)data{
    [super setData:data];
    self.titleLabel.text = data.title;
}

+ (CGFloat)itemHeight:(CGFloat)width{
    return 80;
}
@end

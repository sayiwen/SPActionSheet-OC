//
//  SPActionSheetDefaultItem.m
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import "SPActionSheetDefaultItem.h"
#import "SPActionSheetData.h"
#import <SPLayout/SPLayout.h>
#import <SPTheme/SPTheme.h>


@interface SPActionSheetDefaultItem ()

//titleLabel
@property (nonatomic, weak) UILabel *titleLabel;

//bottom line
@property (nonatomic, weak) UIView *bottomLine;

@end

@implementation SPActionSheetDefaultItem


- (void)setupView{
    [super setupView];
    //rand color
    self.backgroundColor = UIColor.clearColor;
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = SPColor.text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = SPColor.border;
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    SPLayout.layout(self.titleLabel).widthEqual(self).centerY(self).install();
    SPLayout.layout(self.bottomLine).widthEqual(self).bottomToBottomOf(self).height(0.5f).install();
}

- (void)setData:(SPActionSheetData *)data{
    [super setData:data];
    self.titleLabel.text = data.title;
    if (data.last) {
        self.bottomLine.hidden = YES;
    }else{
        self.bottomLine.hidden = NO;
    }
}

+ (CGFloat)itemHeight:(CGFloat)width{
    return 44;
}
@end

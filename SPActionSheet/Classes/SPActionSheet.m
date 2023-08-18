//
//  SPActionSheet.m
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import "SPActionSheet.h"
#import <SPCollectionView/SPCollectionView.h>
#import "SPActionSheetManager.h"
#import "SPActionSheetData.h"
#import <SPCollectionView/SPBaseItem.h>
#import <Masonry/Masonry.h>
#import <SPTheme/SPTheme.h>

//is rtl define static
static BOOL isRtl;

@interface SPActionSheet ()<SPCollectionViewDelegate,UIGestureRecognizerDelegate>

//key
@property (nonatomic, copy) NSString *key;

//window
@property (nonatomic, strong) UIWindow *window;

//data
@property (nonatomic, strong) NSArray<SPViewModel *> *data;

//viewController
@property (nonatomic, strong) UIViewController *viewController;

//collectionView
@property (nonatomic, strong) SPCollectionView *collectionView;

//title
@property (nonatomic, copy) NSString *title;

//container view
@property (nonatomic, strong) UIView *containerView;

//title lable
@property (nonatomic, strong) UILabel *titleLabel;

//close button
@property (nonatomic, strong) UIButton *closeButton;

//scrol is start
@property (nonatomic, assign) BOOL isScrollStart;

//bundle
@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation SPActionSheet

- (NSBundle *)bundle{
    NSBundle *classBundle = [NSBundle bundleForClass:self.class];
    NSBundle * bundle = [NSBundle bundleWithURL:[classBundle URLForResource:@"SPActionSheet" withExtension:@"bundle"]];
    return bundle;
}

+(SPActionSheet *)create:(NSString *)title items:(NSArray<NSString *> *)items{
    NSMutableArray *data = [NSMutableArray new];
    for (NSString *item in items) {
        SPActionSheetData *viewModel = [[SPActionSheetData alloc] init];
        viewModel.title = item;
        viewModel.viewType = SPViewTypeActionSheetDefaultItem;
        [data addObject:viewModel];
    }
    return [self create:title data:data];
}

+(SPActionSheet *)create:(NSString *)title data:(NSArray<SPViewModel *> *)data{
    SPActionSheet *actionSheet = [[SPActionSheet alloc] init];
    actionSheet.title = title;
    actionSheet.data = data;
    actionSheet.key = [NSString stringWithFormat:@"%p",actionSheet];
    [[SPActionSheetManager sharedInstance] addActionSheet:actionSheet key:actionSheet.key];
    return actionSheet;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self seupView];
        self.maskHide = YES;
        self.autoHide = YES;
        self.pullDownHide = YES;
    
    }
    return self;
}

- (void)seupView{
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.hidden = NO;
    self.window = window;
    
    //view controller
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    viewController.view.alpha = 0.0;
    self.viewController = viewController;
    window.rootViewController = viewController;
    
    //container view
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = SPColor.background;
    [viewController.view addSubview:containerView];
    self.containerView = containerView;
    
    
    //title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = [SPTheme shareInstance].isRTL?NSTextAlignmentRight:NSTextAlignmentLeft;
    titleLabel.textColor = SPColor.text;
    titleLabel.font = SPFont.title;
    [containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    //close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"sp_ic_close" inBundle:self.bundle compatibleWithTraitCollection:nil];
    //padding 4
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [closeButton setImage:image forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;
    
    SPCollectionView *collectionView = [SPCollectionView create:self];
    collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView = collectionView;
    [containerView addSubview:collectionView];
    
    [self layoutSubviews];
    
}


- (void)onScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        if (self.isScrollStart && self.pullDownHide) {
            self.isScrollStart = NO;
            [self dismiss];
        }
    }
}

- (void)onScrollBegin:(UIScrollView *)scrollView{
    self.isScrollStart = YES;
}

- (void)onScrollEnd:(UIScrollView *)scrollView{
    self.isScrollStart = NO;
}

- (void)layoutSubviews{
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewController.view);
        make.top.equalTo(self.viewController.view.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if([SPTheme shareInstance].isRTL){
            make.right.equalTo(self.containerView).offset(-15);
        }else{
            make.left.equalTo(self.containerView).offset(15);
        }
        make.top.equalTo(self.containerView.mas_top).offset(10);
        make.height.mas_equalTo(40);
    }];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if([SPTheme shareInstance].isRTL){
            make.left.equalTo(self.containerView).offset(15);
        }else{
            make.right.equalTo(self.containerView).offset(-15);
        }
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(40);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
    
}



- (void)setMaskHide:(BOOL)maskHide{
    _maskHide = maskHide;
    if (maskHide) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self.viewController.view addGestureRecognizer:tap];
    }else{
        for (UIGestureRecognizer *gesture in self.viewController.view.gestureRecognizers) {
            [self.viewController.view removeGestureRecognizer:gesture];
        }
    }
}

- (void)show{
    self.titleLabel.text = self.title;
    [self.collectionView setData:self.data];
    [self.window makeKeyAndVisible];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self showAnimation];
    });
}

- (void)showAnimation{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.viewController.view.alpha = 1.0;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewController.view.mas_bottom).offset(-1 * self.containerView.frame.size.height);
        }];
        [self.viewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];

}


- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewController.view.alpha = 0.0;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewController.view.mas_bottom);
        }];
        [self.viewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        [[SPActionSheetManager sharedInstance] removeActionSheet:self.key];
    }];
}

- (void)onItemClick:(SPCollectionView *)collectionView model:(SPViewModel *)model index:(NSInteger)index{
    if (self.autoHide) {
        [self dismiss];
    }
    if (self.onItemClick) {
        self.onItemClick(model,index);
    }
}


- (void)onGetHeight:(CGFloat)height{
    
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    height += 60;
    
    if (height > [UIScreen mainScreen].bounds.size.height/2) {
        height = [UIScreen mainScreen].bounds.size.height/2;
    }
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self.viewController.view) {
        return NO;
    }
    return YES;
}

@end

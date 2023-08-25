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
#import <SPTheme/SPTheme.h>
#import <SPLayout/SPLayout.h>

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

//first show
@property (nonatomic, assign) BOOL firstShow;


@end

@implementation SPActionSheet

- (NSBundle *)bundle{
    NSBundle *classBundle = [NSBundle bundleForClass:self.class];
    NSBundle * bundle = [NSBundle bundleWithURL:[classBundle URLForResource:@"SPActionSheet" withExtension:@"bundle"]];
    return bundle;
}

+(SPActionSheet *)create:(NSString *)title items:(NSArray<NSString *> *)items{
    NSMutableArray *data = [NSMutableArray new];
    int i = 0;
    for (NSString *item in items) {
        SPActionSheetData *viewModel = [[SPActionSheetData alloc] init];
        viewModel.title = item;
        viewModel.viewType = SPViewTypeActionSheetDefaultItem;
        //set last
        if (i == items.count - 1) {
            viewModel.last = YES;
        }
        i++;
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
        self.cornerRadius = 10;
        self.firstShow = YES;
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
    containerView.backgroundColor = SPColor.secondBackground;
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
    
    SPLayout.layout(self.containerView)
        .widthEqual(self.viewController.view)
        .bottomToBottomOf(self.viewController.view)
        .install();
    
    SPLayout.layout(self.titleLabel)
        .rightToRightOfMargin(self.containerView,15)
        .topToTopOfMargin(self.containerView,10)
        .height(40)
        .install();
    
    SPLayout.layout(self.closeButton)
        .leftToLeftOfMargin(self.containerView,15)
        .centerY(self.titleLabel)
        .size(CGSizeMake(36, 36))
        .install();

    SPLayout.layout(self.collectionView)
        .widthEqual(self.containerView)
        .topToBottomOfMargin(self.titleLabel,10)
        .bottomToBottomOf(self.containerView)
        .install();
    
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


- (void)addData:(NSArray<SPViewModel *> *)data{
    [self.collectionView addData:data];
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
    
    //corner
    if (self.cornerRadius) {
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        // Set the path of the CAShapeLayer to a UIBezierPath with rounded corners on the top only
//        UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds
//                                                          byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
//                                                                cornerRadii:CGSizeMake(10.0, 10.0)];
//        maskLayer.path = roundedPath.CGPath;
//        // Set the mask of the view's layer to the CAShapeLayer
//        self.containerView.layer.mask = maskLayer;
    }
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.viewController.view.alpha = 1.0;
        SPLayout.update(self.containerView)
            .bottomToBottomOf(self.viewController.view)
            .install();
        [self.viewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];

}


- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewController.view.alpha = 0.0;
        SPLayout.update(self.containerView)
            .bottomToBottomOfMargin(self.viewController.view,-1 * self.containerView.frame.size.height)
            .install();
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
    
    height += 60;

    if (height > [UIScreen mainScreen].bounds.size.height/2) {
        height = [UIScreen mainScreen].bounds.size.height/2;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        SPLayout.update(self.collectionView).height(height).install();
        [self.viewController.view layoutIfNeeded];
    
    }];
    
    [self.viewController.view layoutIfNeeded];
    
    
    if(self.firstShow){
        SPLayout.update(self.containerView)
            .bottomToBottomOfMargin(self.viewController.view,-1 * self.containerView.frame.size.height)
            .install();
        [self.viewController.view layoutIfNeeded];
        self.firstShow = NO;
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self.viewController.view) {
        return NO;
    }
    return YES;
}

@end

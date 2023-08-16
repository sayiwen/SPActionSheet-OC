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

@end

@implementation SPActionSheet


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
    }
    return self;
}

- (void)seupView{
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.hidden = NO;
    self.window = window;
    
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    viewController.view.alpha = 0.0;
    self.viewController = viewController;
    window.rootViewController = viewController;
    
    
    SPCollectionView *collectionView = [SPCollectionView create:self];
    collectionView.backgroundColor = [UIColor blueColor];
    self.collectionView = collectionView;
    [viewController.view addSubview:collectionView];
    collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    
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
    [self.collectionView setData:self.data];
    [self.window makeKeyAndVisible];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewController.view.alpha = 1.0;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewController.view.alpha = 0.0;
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:SPCollectionView.class] || [touch.view isKindOfClass:[SPBaseItem class]]) {
        return NO;
    }
    return YES;
}
@end

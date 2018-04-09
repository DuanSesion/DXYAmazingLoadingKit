//
//  JigsawController.m
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawStarGameController.h"
#import "JigsawGameRankController.h"
#import "JigsawGameController.h"

#import "JigsawCollectionReusableView.h"
#import "JigsawAlertView.h"
#import "JigsawListCell.h"
#import "JigsawList.h"

static const CGFloat kStandSpacing = 30.0f;

@interface JigsawStarGameController ()<
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UINavigationControllerDelegate> {
        BOOL _stateHidden;
}

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) id oldDelegate;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UIButton *ruleButton;
@property (nonatomic, weak) UIButton *rankButton;
@property (nonatomic, strong) NSMutableArray <JigsawList *> *datas;
@property (nonatomic, assign) NSUInteger selectIndex;

@end

@implementation JigsawStarGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayouts];
}

- (void)loadView {
    [super loadView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.clipsToBounds = YES;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = [UIImage imageNamed:@"resourse.bundle/loading"];
    bgImageView.highlightedImage = [UIImage imageNamed:@"resourse.bundle/jigsaw_comm_bg_icon"];
    self.view = bgImageView;
    _bgImageView = bgImageView;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[JigsawStarGameController class]] ||
        [viewController isKindOfClass:[JigsawGameRankController class]] ||
        [viewController isKindOfClass:[JigsawGameController class]]) {
        [navigationController setNavigationBarHidden:YES animated:animated];
        
    } else {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JigsawListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JigsawID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[JigsawListCell alloc] init];
    }
   
    if (indexPath.row < self.datas.count) {
        cell.model = self.datas[indexPath.row];
//        if (self.selectIndex == indexPath.row) {
//            cell.layer.borderColor = [UIColor yellowColor].CGColor;
//            
//        } else {
//            cell.layer.borderColor = [UIColor clearColor].CGColor;
//        }
    }
    return cell;
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        JigsawCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerIdentifier" forIndexPath:indexPath];
        view.jigsawBlock = ^(){
            if (self.selectIndex < self.datas.count) {
                JigsawList *model = self.datas[self.selectIndex];
        
                JigsawGameController *vc = [[JigsawGameController alloc] init];
                vc.model = model;
                vc.gameBlock = ^(){
                    model.unClock = YES;
                    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectIndex inSection:0]]];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        return view;
        
    } else {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
        return view;
    }
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [collectionView reloadData];
    
    if (self.selectIndex < self.datas.count) {
        JigsawList *model = self.datas[self.selectIndex];
        
        JigsawGameController *vc = [[JigsawGameController alloc] init];
        vc.model = model;
        vc.gameBlock = ^(){
            model.unClock = YES;
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectIndex inSection:0]]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - data
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (int i = 1; i <= 8; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"美女%02d", i]];
            JigsawList *model = [[JigsawList alloc] init];
            model.image = image;
            [_datas addObject:model];
        }
    }
    return _datas;
}

#pragma mark - Init

- (void)setupLayouts {
    self.title = @"拼图游戏";
    _stateHidden = self.navigationController.navigationBarHidden;
    self.view.backgroundColor = [UIColor whiteColor];
    self.oldDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
    self.selectIndex = 0;
    
    self.collectionView.hidden = NO;
    self.backButton.hidden = NO;
    self.bgImageView.highlighted = YES;
    self.logoImageView.hidden = NO;
    self.ruleButton.hidden = NO;
    self.rankButton.hidden = NO;
    
    [self setRightItemButton];
    [self.collectionView reloadData];
}

- (void)setRightItemButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.f,  0.f, 40.f, 45.f);
    [button setTitle:@"规则" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 10.f;
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/game_back_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/game_back_hiligth_icon"] forState:UIControlStateHighlighted];

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat buttonY = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat buttonW = 40.f;
        CGFloat buttonH = 40.f;
        
        button.frame = CGRectMake(15.f,  buttonY, buttonW, buttonH);
        [self.view addSubview:button];
        _backButton = button;
    }
    return _backButton;
}

- (UIButton *)ruleButton {
    if (!_ruleButton) {
        UIButton *ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ruleButton setImage:[UIImage imageNamed:@"resourse.bundle/jiesaw_rule_normal_icon"] forState:UIControlStateNormal];
        [ruleButton setImage:[UIImage imageNamed:@"resourse.bundle/jiesaw_rule_selected_icon"] forState:UIControlStateHighlighted];
        [ruleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        ruleButton.frame = CGRectMake(self.view.frame.size.width - 68.f, self.backButton.frame.origin.y, 53.f, 34.f);
        
        [ruleButton sizeToFit];
        [self.view addSubview:ruleButton];
        _ruleButton = ruleButton;
    }
    return _ruleButton;
}

- (UIButton *)rankButton {
    if (!_rankButton) {
        UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rankButton setImage:[UIImage imageNamed:@"resourse.bundle/jiesaw_paiming_normal_icon"] forState:UIControlStateNormal];
        [rankButton setImage:[UIImage imageNamed:@"resourse.bundle/jiesaw_paiming_selected_icon"] forState:UIControlStateHighlighted];
        [rankButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        rankButton.frame = CGRectMake(CGRectGetMinX(self.ruleButton.frame), CGRectGetMaxY(self.ruleButton.frame) + 10.f, 53.f, 34.f);
        [rankButton sizeToFit];
        [self.view addSubview:rankButton];
        _rankButton = rankButton;
    }
    return _rankButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_logo_icon"]];
        [self.view insertSubview:logoImageView atIndex:0];
        logoImageView.center = CGPointMake(self.view.center.x, [UIApplication sharedApplication].statusBarFrame.size.height + 45.f);
        
        
        _logoImageView = logoImageView;
    }
    return _logoImageView;
}

- (void)buttonAction:(id)sender {
    if (_backButton == sender) {
        self.navigationController.delegate = _oldDelegate;
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController setNavigationBarHidden:_stateHidden animated:YES];
        
    } else if (_rankButton == sender) {
        JigsawGameRankController *rankController = [[JigsawGameRankController alloc] init];
        [self.navigationController pushViewController:rankController animated:YES];
        
    } else {
        [JigsawAlertView jigsawAlertViewShowWithTitle:
         @" 1.每张拼图每日首次完成可以获取2积分，完成后解锁下一张拼图。\n\n2.每日可拼6张拼图，并获得相应的积分。\n\n3.最终解释权归唐大大科技有限公司所有。" textAlignment:NSTextAlignmentLeft compled:nil];
    }
}

- (UICollectionViewFlowLayout *)collectionFlowLayout {
    if (!_collectionFlowLayout) {
        UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        collectionFlowLayout.minimumInteritemSpacing = kStandSpacing * 0.3f;
        collectionFlowLayout.minimumLineSpacing = kStandSpacing * 0.3f;
        collectionFlowLayout.headerReferenceSize = CGSizeMake(0.0f, 100.f);
        collectionFlowLayout.footerReferenceSize = CGSizeMake(0.0f, 85.f);
        collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0.0f, kStandSpacing, 0.0f, kStandSpacing);
        CGFloat width = (self.view.bounds.size.width - kStandSpacing * 3) / 2;
        
        // collectionFlowLayout.itemSize = CGSizeMake(width, width + 40.f);
        collectionFlowLayout.itemSize = CGSizeMake(width, width);
        _collectionFlowLayout = collectionFlowLayout;
    }
    return _collectionFlowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:self.collectionFlowLayout];
        [collectionView registerClass:[JigsawListCell class] forCellWithReuseIdentifier:@"JigsawID"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
        [collectionView registerClass:[JigsawCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerIdentifier"];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        CGRect frame = self.view.bounds;
        frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height = self.view.frame.size.height - frame.origin.y;
        collectionView.frame = frame;
        
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}


@end

//
//  JigsawGameController.m
//  XDGame
//
//  Created by imac on 2018/2/26.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawGameController.h"
#import "JigsawGameRankController.h"
#import "JigsawGameCell.h"
#import "JigsawGame.h"
#import "UIAlertController+GMAddition.h"
#import "JigsawList.h"
#import "JigsawAlertView.h"

#define XCOUNT      3
#define YCOUNT      3
#define KTIMER      60

static const CGFloat kStandSpacing = 1.0f;

@interface JigsawGameController ()<
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UIButton *ruleButton;
@property (nonatomic, weak) UIButton *rankButton;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *gameBackgrundImageView;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton *starButton;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) NSMutableArray <JigsawGame *>*datas;
@property (nonatomic, strong) NSMutableArray <JigsawGame *>*oldDatas;

@property (nonatomic, strong) JigsawGame *selectJigsawGame;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, assign) BOOL update;
@property (nonatomic, assign) BOOL animation;

@end

@implementation JigsawGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayouts];
    // jisaw_game_background_icon
}

- (void)loadView {
    [super loadView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.clipsToBounds = YES;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = [UIImage imageNamed:@"resourse.bundle/jigsaw_gamerank_bg_icon"];
    self.view = bgImageView;
}

#pragma mark - data.image
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        
        if (self.model.image) {
            CGFloat CUT_WIDTH = self.model.image.size.width;
            CGFloat CUT_HEIGHT = self.model.image.size.height;
            
            for (NSUInteger i = 0; i < YCOUNT; i++) {
                for (NSUInteger j = 0; j < XCOUNT; j++) {
                    CGRect rect = CGRectMake(CUT_WIDTH / XCOUNT * j + 2 * (j + 1), CUT_HEIGHT / YCOUNT * i + 2 * (i + 1), CUT_WIDTH / XCOUNT, CUT_HEIGHT / YCOUNT);
                    
                    UIImage *image = [self clipImage:self.model.image withRect:rect];
                    
                    JigsawGame *model = [[JigsawGame alloc] init];
                    model.normalImage = image;
                    model.selectImage = [JigsawGame imageByApplyingAlpha:0.75f image:image];
                    [_datas addObject:model];
                }
            }
            _oldDatas = _datas.mutableCopy;
            [self orderPicture];
        }
    }
    return _datas;
}

// 打乱顺序
- (void)orderPicture{
    NSInteger count = _datas.count;
    while (count > 0) {
        // 获取随机角标
        NSInteger index = arc4random_uniform((int)(count - 1));
        [_datas exchangeObjectAtIndex:index withObjectAtIndex:count - 1];
        count--;
    }
}

// 切割图片
- (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect
{
    CGImageRef CGImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    return [UIImage imageWithCGImage:CGImage];
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JigsawGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JigsawGameCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[JigsawGameCell alloc] init];
        cell.backgroundColor = [UIColor grayColor];
    }
    
    if (indexPath.row < self.datas.count) {
        
         JigsawGame *model = self.datas[indexPath.row];
         UIImage *imgae = model.normalImage;
         cell.layer.contents = (id)imgae.CGImage;
         cell.isSelected = model.selected;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
    
    if (indexPath.row < self.datas.count) {
        JigsawGame *selectJigsawGame = self.datas[indexPath.row];
        if (_selectJigsawGame == nil) {
            _selectJigsawGame = selectJigsawGame;
            _selectJigsawGame.selected = YES;
            [collectionView reloadData];
            
        } else {
            _selectJigsawGame.selected = NO;
            
            NSInteger index = [self.datas indexOfObject:_selectJigsawGame];
            NSInteger change = [self.datas indexOfObject:selectJigsawGame];
            if (index != change) {
                [self.datas exchangeObjectAtIndex:index withObjectAtIndex:change];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0],
                                                          [NSIndexPath indexPathForItem:change inSection:0]]];
                
                if ([_oldDatas isEqualToArray:self.datas]) {
 
                    
                    [self endGame];
                    
                    [JigsawAlertView jigsawAlertViewShowWithTitle:
                     @" 恭喜您完成拼图\n获得2积分" textAlignment:NSTextAlignmentCenter compled:^{
                    
                         if (_gameBlock) {
                             _gameBlock();
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     }];
                }
                
            } else { // 取消选择
                _selectJigsawGame.selected = NO;
                [collectionView reloadData];
            }
            _selectJigsawGame = nil;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.animation) {
        CATransform3D rotation;// 3D旋转
        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        // 逆时针旋转
        rotation = CATransform3DScale(rotation, 0.8, 0.8, 1);
        rotation.m34 = 1.0/ 1000;
        cell.layer.shadowColor = [[UIColor redColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        [UIView beginAnimations:@"rotation" context:NULL];
        // 旋转时间
        
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
        
        if (indexPath.row == self.datas.count - 1) {
             self.animation = NO;
        }
    }
}

#pragma mark - init
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

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_logo_icon"]];
        [self.view insertSubview:logoImageView atIndex:0];
        logoImageView.center = CGPointMake(self.view.center.x, [UIApplication sharedApplication].statusBarFrame.size.height + 60.f);
        _logoImageView = logoImageView;
    }
    return _logoImageView;
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

- (UIImageView *)gameBackgrundImageView {
    if (!_gameBackgrundImageView) {
        UIImageView *gameBackgrundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resourse.bundle/jisaw_game_background_icon"]];
        gameBackgrundImageView.userInteractionEnabled = YES;
        
        CGFloat itemSize = (self.view.bounds.size.width - 40.f - kStandSpacing * (YCOUNT + 1)) / YCOUNT;
        
        CGFloat gY = CGRectGetMaxY(self.logoImageView.frame) + 15.f;
        CGFloat gW = self.view.frame.size.width - 30.f;
        CGFloat gH = XCOUNT * itemSize + (XCOUNT) * kStandSpacing + 65.f;
        
        gameBackgrundImageView.frame = CGRectMake(15.f, gY, gW, gH);
        gameBackgrundImageView.clipsToBounds = YES;
        [self.scrollView addSubview:gameBackgrundImageView];
        _gameBackgrundImageView = gameBackgrundImageView;
    }
    return _gameBackgrundImageView;
}

- (void)setupLayouts {
    self.title = @"拼图游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.animation = YES;

    self.scrollView.hidden = NO;
    self.gameBackgrundImageView.hidden = NO;
    self.label.hidden = NO;
    self.starButton.hidden = NO;
    self.logoImageView.hidden = NO;
    self.backButton.hidden = NO;
    self.ruleButton.hidden = NO;
    self.rankButton.hidden = NO;
    
    [self.collectionView reloadData];
}

- (UIButton *)starButton {
    if (!_starButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 10.f;
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_star_button_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_star_button_hilight"] forState:UIControlStateHighlighted];
        
        CGFloat buttonX = 30.f;
        CGFloat buttonY = CGRectGetMaxY(self.gameBackgrundImageView.frame) + 40.f;
        CGFloat buttonW = self.gameBackgrundImageView.frame.size.width - 30.f;
        CGFloat buttonH = 50.f;

        button.frame = CGRectMake(buttonX,  buttonY, buttonW, buttonH);
        [self.scrollView addSubview:button];
        self.scrollView.contentSize = CGSizeMake(0.f, CGRectGetMaxY(button.frame) + 15.f);
        _starButton = button;
    }
    return _starButton;
}

- (void)buttonAction:(id)sender {
    if (_starButton == sender) {
        if (_update) {
            [self orderPicture];
            [self.collectionView reloadData];
        }
        
        _starButton.hidden = YES;
        self.collectionView.userInteractionEnabled = YES;
        _timer = nil;
        [_timer invalidate];
        
        _timeCount = KTIMER;
        self.label.text = [NSString stringWithFormat:@"%d", KTIMER];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            self.label.text = [NSString stringWithFormat:@"%02ld", _timeCount];
            
            if (_timeCount <= 0) {
               [self endGame];
//               UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"游戏失败" actionWithCancel:@"知道了" cancel:^(UIAlertAction *action) {
                    _update = NO;
                    [self orderPicture];
                    [self.collectionView reloadData];
//                }];
//               [self presentViewController:alert animated:YES completion:nil];
            }
            _timeCount--;
        }];
        
    } else if (_backButton == sender) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (_rankButton == sender) {
        JigsawGameRankController *rankController = [[JigsawGameRankController alloc] init];
        [self.navigationController pushViewController:rankController animated:YES];
        
    } else {
        [JigsawAlertView jigsawAlertViewShowWithTitle:
         @" 1.每张拼图每日首次完成可以获取2积分，完成后解锁下一张拼图。\n\n2.每日可拼6张拼图，并获得相应的积分。\n\n3.最终解释权归唐大大科技有限公司所有。" textAlignment:NSTextAlignmentLeft compled:nil];
    }
}

- (void)endGame {
    _starButton.hidden = NO;
    self.collectionView.userInteractionEnabled = NO;
    
    [_timer invalidate];
    _timer = nil;
    _update = YES;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.frame = self.view.bounds;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18.f];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d", KTIMER];
        
        CGFloat labelY = 15.f;
        CGFloat labelW = self.gameBackgrundImageView.frame.size.width;
        CGFloat labelH = 20.f;
        
        label.frame = CGRectMake(0.f, labelY, labelW, labelH);
        [self.gameBackgrundImageView addSubview:label];
        _label = label;
    }
    return _label;
}

- (UICollectionViewFlowLayout *)collectionFlowLayout {
    if (!_collectionFlowLayout) {
        UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        collectionFlowLayout.minimumInteritemSpacing = kStandSpacing;
        collectionFlowLayout.minimumLineSpacing = kStandSpacing;
        collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0.0f, kStandSpacing, 0.0f, kStandSpacing);
        CGFloat width = (self.view.bounds.size.width - 40.f - kStandSpacing * (YCOUNT + 1)) / YCOUNT;
        
        collectionFlowLayout.itemSize = CGSizeMake(width, width);
        _collectionFlowLayout = collectionFlowLayout;
    }
    return _collectionFlowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:self.collectionFlowLayout];
        [collectionView registerClass:[JigsawGameCell class] forCellWithReuseIdentifier:@"JigsawGameCell"];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        collectionView.userInteractionEnabled = NO;
        
        CGFloat itemSize = (self.view.bounds.size.width - 40.f - kStandSpacing * (YCOUNT + 1)) / YCOUNT;
        
        CGFloat collectionY = CGRectGetMaxY(self.label.frame) + 15.f;
        CGFloat collectionW = self.view.frame.size.width - 40.f;
        CGFloat collectionH = XCOUNT * itemSize + (XCOUNT) * kStandSpacing;
        
        collectionView.frame = CGRectMake(5.f, collectionY, collectionW, collectionH);
        [self.gameBackgrundImageView addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end

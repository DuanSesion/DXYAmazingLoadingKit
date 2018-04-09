//
//  JigsawGameRankController.m
//  XDGame
//
//  Created by imac on 2018/3/27.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawGameRankController.h"
#import "JigsawGameRankCell.h"

@interface JigsawGameRankController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation JigsawGameRankController

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
    bgImageView.image = [UIImage imageNamed:@"resourse.bundle/jigsaw_gamerank_bg_icon"];
    self.view = bgImageView;
}

- (void)buttonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JigsawGameRankCell *cell = [JigsawGameRankCell jigsawGameRankCellWith:tableView indexPath:indexPath];
 
    return cell;
}

#pragma  mark - v
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
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resourse.bundle/jigsaw_gamerank_log_icon"]];
        [self.view insertSubview:logoImageView atIndex:0];
        logoImageView.center = CGPointMake(self.view.center.x, [UIApplication sharedApplication].statusBarFrame.size.height + 60.f);
        _logoImageView = logoImageView;
    }
    return _logoImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorInset = UIEdgeInsetsMake(0.f, -1.5f, 0.f, 1.5f);
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 1.f)];
        
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"resourse.bundle/jigsaw_gamerank_list_icon"];
        bg.clipsToBounds = YES;
        bg.contentMode = UIViewContentModeScaleToFill;
        bg.frame = CGRectMake(20.f, CGRectGetMaxY(self.logoImageView.frame) + 15.f, self.view.frame.size.width - 40.f, bg.image.size.height);
        [self.view addSubview:bg];
        
        tableView.frame = CGRectMake(20.f, CGRectGetMaxY(self.logoImageView.frame) + 15.f + 35., self.view.frame.size.width - 40.f, bg.image.size.height - 45.f);
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)setupLayouts {
    self.view.backgroundColor = [UIColor whiteColor];
    self.backButton.hidden = NO;
    self.logoImageView.hidden = NO;
    [self.tableView reloadData];
    
}

@end

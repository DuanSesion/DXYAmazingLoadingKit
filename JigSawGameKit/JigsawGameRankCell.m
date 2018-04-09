//
//  JigsawGameRankCell.m
//  XDGame
//
//  Created by imac on 2018/3/28.
//  Copyright © 2018年 imac. All rights reserved.
//

#import "JigsawGameRankCell.h"

@interface JigsawGameRankCell ()

@property (nonatomic, weak) UILabel *rankLabel;
@property (nonatomic, weak) UILabel *nickLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation JigsawGameRankCell

+ (id)jigsawGameRankCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    JigsawGameRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[JigsawGameRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        UILabel *rankLabel = [[UILabel alloc] init];
        rankLabel.font = [UIFont boldSystemFontOfSize:13.f];
        rankLabel.textColor = [UIColor whiteColor];
        rankLabel.textAlignment = NSTextAlignmentCenter;
        rankLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        rankLabel.frame = CGRectMake(0.f, 0.f, 0.161f * CGRectGetWidth([UIScreen mainScreen].bounds), self.frame.size.height);
        [self.contentView addSubview:rankLabel];
        _rankLabel = rankLabel;
    }
    return _rankLabel;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.font = [UIFont boldSystemFontOfSize:13.f];
        nickLabel.textColor = [UIColor whiteColor];
        nickLabel.textAlignment = NSTextAlignmentCenter;
        nickLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nickLabel.frame = CGRectMake(self.rankLabel.frame.size.width, 0.f, 0.412f * CGRectGetWidth([UIScreen mainScreen].bounds), self.frame.size.height);
        [self.contentView addSubview:nickLabel];
        _nickLabel = nickLabel;
    }
    return _nickLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont boldSystemFontOfSize:13.f];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        timeLabel.frame = CGRectMake(CGRectGetMaxX(self.nickLabel.frame), 0.f, 0.319f * CGRectGetWidth([UIScreen mainScreen].bounds), self.frame.size.height);
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (void)setup {
    self.rankLabel.text = @"100";
    self.nickLabel.text = @"昵称    ";
    self.timeLabel.text = @"00:00:00";
}

@end

//
//  AlbumPhotoCell.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "AlbumPhotoCell.h"
#import "DDHAttributedMode.h"
@implementation AlbumPhotoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 50, 50)];
        self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.firstImageView.clipsToBounds = YES;
        self.firstImageView.layer.cornerRadius = 5;
        self.firstImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.firstImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstImageView.frame)+15, 0, 200, 70)];
        self.nameL.font = SIXTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.nameL];
    }
    return self;
}

- (void)setAlbumM:(TZAlbumModel *)albumM{
    
    self.nameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@ %ld",albumM.name,albumM.count] setSize:12 setLengthString:[NSString stringWithFormat:@"%ld",albumM.count] beginSize:[NSString stringWithFormat:@"%@ ",albumM.name].length];
    if (!albumM.models.count) {
        self.firstImageView.image = UIImageNamed(@"img_empty");
        return;
    }
    TZAssetModel *model = albumM.models[0];
 
    [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:50 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
       
        self.firstImageView.image = photo;
    } progressHandler:nil networkAccessAllowed:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

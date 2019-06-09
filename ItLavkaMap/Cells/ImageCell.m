//
//  ImageCell.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/9/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "ImageCell.h"
@interface ImageCell ()
    
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
    
@end

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 6.0;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

@end

//
//  PhotoPickerView.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/9/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "PhotoPickerView.h"
#import "ImageCell.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <AVFoundation/AVFoundation.h>

static NSString *const CellIdentifier = @"imageCell";

@interface PhotoPickerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *imagesArray;

@end

@implementation PhotoPickerView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}
    
    
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}
    
- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    self.imagesArray = [[NSMutableArray alloc] init];
}
    
#pragma mark - UICollectionViewDataSource
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}
    
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setImage:self.imagesArray[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(46.0, 46.0);
}
    
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    [self.imagesArray addObject:pickedImage];
    [self.collectionView reloadData];
}
    
- (IBAction)addPhotoButtonAction:(UIButton *)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkAndOpenCamera];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkAndOpenMediaLibrary];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:^{}];
}


- (void)checkAndOpenMediaLibrary {
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
                    });
                }
            }];
        }
        break;
        
        case PHAuthorizationStatusAuthorized:
        [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
        break;
        
        default:
        break;
    }
}
    
- (void)checkAndOpenCamera {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto:UIImagePickerControllerSourceTypeCamera];
                    });
                }
            }];
        }
        break;
        
        case AVAuthorizationStatusAuthorized:
        [self takePhoto:UIImagePickerControllerSourceTypeCamera];
        break;
        
        default:
        break;
    }
}

- (void)takePhoto:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = self;
    [pickerViewController setSourceType:sourceType];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pickerViewController animated:YES completion:nil];
}

@end

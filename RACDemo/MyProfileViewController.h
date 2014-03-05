//
//  MyProfileViewController.h
//  moon
//
//  Created by wenlin on 13-9-15.
//  Copyright (c) 2013年 wenlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (strong,nonatomic) NSMutableArray *clues;

@end

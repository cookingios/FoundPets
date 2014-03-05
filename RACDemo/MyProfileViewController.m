//
//  MyProfileViewController.m
//  moon
//
//  Created by wenlin on 13-9-15.
//  Copyright (c) 2013年 wenlin. All rights reserved.
//

#import "MyProfileViewController.h"
#import "CluesEventCell.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <RESideMenu.h>

@interface MyProfileViewController (){
    
    PFObject *parentEvent;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cluesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adoptCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cluesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *collectionTitleLabel;

- (IBAction)showMenu:(id)sender;
- (IBAction)setting:(id)sender;

@end

@implementation MyProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_clues) {
        _clues = [[NSMutableArray alloc]initWithCapacity:3];
        
    }
    
    UITapGestureRecognizer *tapClues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getClues)];
    UITapGestureRecognizer *tapLosts = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getLosts)];
    UITapGestureRecognizer *tapAdopts = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getAdopts)];
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar:)];
    [_lostsCountLabel addGestureRecognizer:tapLosts];
    [_cluesCountLabel addGestureRecognizer:tapClues];
    [_adoptCountLabel addGestureRecognizer:tapAdopts];
    [_avatarImageView addGestureRecognizer:tapAvatar];
    
    
    [self configHeaderView];
    [self getClues];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configHeaderView{
    
    [[_avatarImageView layer] setMasksToBounds: YES];
    [[_avatarImageView layer] setCornerRadius:(_avatarImageView.bounds.size.width/2.0)];
    self.lostsCountLabel.layer.cornerRadius = 3.0f;
    self.lostsCountLabel.layer.masksToBounds = YES;
    self.cluesCountLabel.layer.cornerRadius = 3.0f;
    self.cluesCountLabel.layer.masksToBounds = YES;
    self.adoptCountLabel.layer.cornerRadius = 3.0f;
    self.adoptCountLabel.layer.masksToBounds = YES;
    PFFile * avatar = [[PFUser currentUser] objectForKey:@"avatar"];
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[avatar url]]  placeholderImage:nil] ;
    _nameLabel.text =[[PFUser currentUser] objectForKey:@"displayName"];
    
    
    //丢失数量数量
    PFQuery *queryLosts = [PFQuery queryWithClassName:@"Event"];
    queryLosts.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [queryLosts whereKey:@"organizer" equalTo:[PFUser currentUser]];
    [queryLosts whereKey:@"type" equalTo:@"lost"];
    [queryLosts countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            _lostsCountLabel.text =[NSString stringWithFormat:@"%i 丢失",count];
        } else {
            // The request failed
        }
    }];
    
    
    //线索提供数量
    PFQuery *queryReports = [PFQuery queryWithClassName:@"Event"];
    queryReports.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [queryReports whereKey:@"organizer" equalTo:[PFUser currentUser]];
    [queryReports whereKey:@"type" equalTo:@"clue"];
    [queryReports countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            _cluesCountLabel.text =[NSString stringWithFormat:@"%i 线索",count];
        } else {
            // The request failed
        }
    }];
    
    //线索提供数量
    PFQuery *queryAdopts = [PFQuery queryWithClassName:@"Event"];
    queryAdopts.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [queryAdopts whereKey:@"organizer" equalTo:[PFUser currentUser]];
    [queryAdopts whereKey:@"type" equalTo:@"adopt"];
    [queryAdopts countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            _adoptCountLabel.text =[NSString stringWithFormat:@"%i 领养",count];
        } else {
            // The request failed
        }
    }];

}

#pragma mark - 获取我的发布
-(void)getClues{
    _collectionTitleLabel.alpha = 0.0;
    NSLog(@"fetching my clue events...");
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _collectionTitleLabel.alpha = 1;
        _collectionTitleLabel.text = @"我提供的线索";
    } completion:^(BOOL finished) {
    }];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"organizer" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:@"clue"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query includeKey:@"organizer"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%ld",(long)[objects count]);
            _clues = [objects mutableCopy];
            [_cluesCollectionView reloadData];
            CGSize size = [_cluesCollectionView.collectionViewLayout collectionViewContentSize];
            _cluesCollectionView.frame = CGRectMake (_cluesCollectionView.frame.origin.x,_cluesCollectionView.frame.origin.y,size.width,size.height+10);
        }else NSLog(@"%@",error);
        
        
    }];
    
}

- (void)getLosts{
    
    NSLog(@"fetching my lost events...");
     _collectionTitleLabel.alpha = 0.0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _collectionTitleLabel.alpha = 1;
        _collectionTitleLabel.text = @"我发布的丢失";
    } completion:^(BOOL finished) {
    }];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"organizer" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:@"lost"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query includeKey:@"organizer"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%ld",(long)[objects count]);
            _clues = [objects mutableCopy];
            [_cluesCollectionView reloadData];
            CGSize size = [_cluesCollectionView.collectionViewLayout collectionViewContentSize];
            _cluesCollectionView.frame = CGRectMake (_cluesCollectionView.frame.origin.x,_cluesCollectionView.frame.origin.y,size.width,size.height+10);
        }else NSLog(@"%@",error);
        
    }];

    
}

- (void)getAdopts{
    
    NSLog(@"fetching my adopt events...");
    _collectionTitleLabel.alpha = 0.0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _collectionTitleLabel.alpha = 1;
        _collectionTitleLabel.text = @"我发布的领养";
    } completion:^(BOOL finished) {
    }];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"organizer" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:@"adopt"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query includeKey:@"organizer"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%ld",(long)[objects count]);
            _clues = [objects mutableCopy];
            [_cluesCollectionView reloadData];
            CGSize size = [_cluesCollectionView.collectionViewLayout collectionViewContentSize];
            _cluesCollectionView.frame = CGRectMake (_cluesCollectionView.frame.origin.x,_cluesCollectionView.frame.origin.y,size.width,size.height+10);
        }else NSLog(@"%@",error);
        
    }];
    
    
}
#pragma mark - collectionView datasource & delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_clues count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CluesEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CluesEventCell"
                                                                  forIndexPath:indexPath];
    
    
    NSDictionary *event = [_clues objectAtIndex:[indexPath row]];
    PFFile *thumbNail = [[event objectForKey:@"images"] objectAtIndex:0];
    NSURL *URL = [NSURL URLWithString:[thumbNail url]];
    //[cell.clueImageView setImageWithURL:URL];
    [cell.clueImageView setImageWithURL:URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
     
    }];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    parentEvent = [_clues objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"MyEventDetailSegue" sender:self];
}


#pragma mark - actionsheet
- (IBAction)showMenu:(id)sender {
    
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)setting:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"个人资料设置",@"条款与隐私",@"登出账号",nil];
    
    [actionSheet setDestructiveButtonIndex:2];
    [actionSheet setTag:180];
    [actionSheet showInView:self.navigationController.view];
    
    
}

- (IBAction)changeAvatar:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"更换个人头像"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍一张",@"从相册获取",nil];
    
    [actionSheet setTag:240];
    [actionSheet showInView:self.navigationController.view];
    
    
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==180) {
        
        if (buttonIndex==0) {
            [self performSegueWithIdentifier:@"setProfileSegue" sender:self];
        }
        
        if (buttonIndex==1) {
            [self performSegueWithIdentifier:@"showAgreementSegue" sender:self];
        }
        if (buttonIndex==2) {
            [PFUser logOut];
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"] animated:NO completion:nil];
        }
    }else if (actionSheet.tag==240){
        switch (buttonIndex) {
            case 0:
                [self takePhotoFromCamera];
                break;
                
            case 1:
                [self takePictureFromPhotoLibrary];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - deal with pic
- (void)takePhotoFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        
    }
}

- (void)takePictureFromPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData *imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.7f);
    [_avatarImageView setImage:[UIImage imageWithData:imgData]];
    PFFile *avatar = [PFFile fileWithData:imgData];

    [[PFUser currentUser] setObject:avatar forKey:@"avatar"];
    [[PFUser currentUser] saveInBackground];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id dvc = [segue destinationViewController];
    
    if ([[segue identifier]isEqualToString:@"MyEventDetailSegue"]){
        
        [dvc setValue:parentEvent forKey:@"myEvent"];
        
    }
}




@end

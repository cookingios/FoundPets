//
//  SetProfileViewController.m
//  moon
//
//  Created by wenlin on 13-9-16.
//  Copyright (c) 2013年 wenlin. All rights reserved.
//

#import "SetProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface SetProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


- (IBAction)dismissViewController:(id)sender;

@end

@implementation SetProfileViewController

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



}

-(void)viewWillAppear:(BOOL)animated{
    
    [self configProfile];
    
}

-(void)configProfile{
    
    PFFile *avatar = [[PFUser currentUser] objectForKey:@"avatar"];
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[avatar url]] placeholderImage:nil];
    
    _nameLabel.text = [[PFUser currentUser]objectForKey:@"displayName"];
    NSString *gender = [[PFUser currentUser]objectForKey:@"gender"];
    
    if ([gender isEqualToString:@"male"]) {
        _genderLabel.text = @"男";
    }else if([gender isEqualToString:@"female"]){
        _genderLabel.text = @"女";
    }else _genderLabel.text = @"";

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍一张",@"从相册中选取",nil];
    
    if (indexPath.section==0) {
        [actionSheet showInView:self.navigationController.view];
        return;
    }
    
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"SetNameSegue" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"SetGenderSegue" sender:self];
                break;
                
            default:
                break;
        }
        
        return;
    }
    return;
    
 }

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self takePictureFromCamera];
            break;
        case 1:
            [self takePictureFromLibrary];
            break;
            
        default:
            break;
    }
    
}

//开始拍照
-(void)takePictureFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [MUtility showAlert: @"温馨提示"
                       message: @"无法打开摄像头"];
    }
}

//打开本地相册
-(void)takePictureFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [MUtility showAlert: @"温馨提示"
                       message: @"此设备不支持图库操作"];
    }
}


-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSData * imageData= UIImageJPEGRepresentation([info objectForKey: UIImagePickerControllerEditedImage], 0.5f);

    PFFile *avatar = [PFFile fileWithData:imageData];    
    [[PFUser currentUser] setObject:avatar forKey:@"avatar"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFFile *avatar = [[PFUser currentUser] objectForKey:@"avatar"];
            [_avatarImageView setImageWithURL:[NSURL URLWithString:[avatar url]] placeholderImage:nil];
        }
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

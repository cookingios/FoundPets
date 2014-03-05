//
//  CreateGuideStep2ViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-25.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "CreateGuideStep2ViewController.h"

@interface CreateGuideStep2ViewController ()

@property (strong,nonatomic) NSMutableArray* images;
@property (strong,nonatomic) NSData* imgData;


@end

@implementation CreateGuideStep2ViewController

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
    if (!self.images) {
        self.images = [[NSMutableArray alloc]initWithCapacity:1];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view datasource & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self takePictureFromPhotoLibrary];
            break;
        case 1:
            [self takePhotoFromCamera];
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
    
    
}

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
    self.imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.5f);
    
    [picker dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"SubmitSegue" sender:self];
    }];
    
   
    
    
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    id dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"SubmitSegue"]) {
        [dvc setValue:self.type forKey:@"type"];
        [dvc setValue:self.imgData forKey:@"imgData"];
    }
 
}

@end

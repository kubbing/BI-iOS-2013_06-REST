//
//  NewFeedViewController.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 11.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "NewFeedViewController.h"

@import MobileCoreServices;

@interface NewFeedViewController ()

@property (strong, nonatomic) UIImage *pickedImage;
@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation NewFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 64 +8, 304, 44)];
    textField.tintColor = [UIColor redColor];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.text = @"awesome post";
    textField.placeholder = @"sem zadej text…";
    textField.delegate = self;
    [self.view addSubview:textField];
    self.textField = textField;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 320, 320)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(8, 140, 300, 44);
    [button setTitle:@"vyber obrazek awesome" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)cancelAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"_IMAGE_PICK_TITLE", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"_CANCEL", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"_IMAGE_PICK_LIBRARY", nil), NSLocalizedString(@"_IMAGE_PICK_CAMERA", nil),  nil];
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self presentPhotoLibrary];
            break;
        case 1:
            [self presentCamera];
            break;
        case 2:
            ;
            break;
            
        default:
            break;
    }
}

- (void)presentPhotoLibrary
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)presentCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    TRC_ENTRY;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    }
    
    DEFINE_BLOCK_SELF;
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   blockSelf.pickedImage = image;
                                   blockSelf.imageView.image = image;
                               }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
}

@end

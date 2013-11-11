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
@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) UITextField *textField;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pošli" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction:)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    textField.delegate = self;
    textField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:textField];
    self.textField = textField;
    [textField becomeFirstResponder];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cameraButton.frame = CGRectMake(8, 100, 100, 44);
    [cameraButton setTitle:@"Vyber obrazek" forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 100, 304, 403)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)sendAction:(id)sender
{
    TRC_ENTRY;
}

- (void)cameraAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"_IMAGE_PICK_TITLE", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"_CANCEL", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"_IMAGE_PICK_LIBRARY", nil), NSLocalizedString(@"_IMAGE_PICK_CAMERA", nil),  nil];
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    TRC_LOG(@"didDismissWithButtonIndex tag: %d, button: %d", actionSheet.tag, buttonIndex);
    

    switch (buttonIndex) {
        case 0: // camera
            [self presentPhotoLibrary];
            break;
        case 1: // library
            [self presentCamera];
            break;
        case 2: // cancel
            break;
        default:
            break;
    }
}

- (void)presentPhotoLibrary
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    TRC_ENTRY;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

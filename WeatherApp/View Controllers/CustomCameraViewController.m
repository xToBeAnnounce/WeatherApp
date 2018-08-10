//
//  CustomCameraViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/6/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "CustomCameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CustomCameraViewController () <AVCapturePhotoCaptureDelegate>
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UIImageView *captureImageView;

@property (strong, nonatomic) UIButton *snapshotButton;
@property (strong, nonatomic) UIButton *addPhotoButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMasterUI];
    [self configureAVCapture];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.videoPreviewLayer.frame = self.previewView.bounds;
    [self.previewView bringSubviewToFront:self.captureImageView];
    [self.previewView bringSubviewToFront:self.snapshotButton];
    [self.previewView bringSubviewToFront:self.addPhotoButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initalizeButtons {
    // Take photo Button
    self.snapshotButton = [[UIButton alloc] init];
    [self.snapshotButton addTarget:self action:@selector(onTapCapture:) forControlEvents:UIControlEventTouchUpInside];
    [self.snapshotButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    self.snapshotButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.previewView addSubview:self.snapshotButton];
    
    // Add Photo Button
    self.addPhotoButton = [[UIButton alloc] init];
    [self.addPhotoButton addTarget:self action:@selector(onTapAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.addPhotoButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    self.addPhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.previewView addSubview:self.addPhotoButton];
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = self.cancelButton;
}

// sets UI for capture view and preview view
- (void) setViewsUI {
    self.previewView = [[UIView alloc] init];
    self.previewView.translatesAutoresizingMaskIntoConstraints = NO;
    self.previewView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.previewView];
    
    self.captureImageView = [[UIImageView alloc] init];
    self.captureImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.captureImageView.clipsToBounds = YES;
    self.captureImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.captureImageView.backgroundColor = UIColor.clearColor;
    self.captureImageView.layer.cornerRadius = 10;
    self.captureImageView.layer.borderColor = [[[UIColor alloc] initWithWhite:1.0 alpha:0.8] CGColor];
    self.captureImageView.layer.borderWidth = 1;
    [self.previewView addSubview:self.captureImageView];
}

- (void) setNavigationUI {
    self.navigationController.navigationBar.backgroundColor = UIColor.clearColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void) setConstraints {
    // View constraints
    [self.previewView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.previewView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.previewView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.previewView.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    [self.previewView.heightAnchor constraintEqualToConstant:self.view.frame.size.height].active = YES;
    
    [self.captureImageView.leadingAnchor constraintEqualToAnchor:self.previewView.leadingAnchor constant:8].active = YES;
    [self.captureImageView.bottomAnchor constraintEqualToAnchor:self.previewView.bottomAnchor constant:-8].active = YES;
    [self.captureImageView.heightAnchor constraintEqualToAnchor:self.previewView.heightAnchor multiplier:1.0/5.0].active = YES;
    [self.captureImageView.widthAnchor constraintEqualToAnchor:self.captureImageView.heightAnchor multiplier:9.0/16.0].active = YES;
    
    // Button constraints
    [self.snapshotButton.centerXAnchor constraintEqualToAnchor:self.previewView.centerXAnchor].active = YES;
    [self.snapshotButton.bottomAnchor constraintEqualToAnchor:self.previewView.bottomAnchor constant:-15].active = YES;
    [self.snapshotButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.snapshotButton.widthAnchor constraintEqualToAnchor:self.snapshotButton.heightAnchor].active = YES;
    
    [self.addPhotoButton.trailingAnchor constraintEqualToAnchor:self.previewView.trailingAnchor constant:-8].active = YES;
    [self.addPhotoButton.bottomAnchor constraintEqualToAnchor:self.previewView.bottomAnchor constant:-15].active = YES;
    [self.addPhotoButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.addPhotoButton.widthAnchor constraintEqualToAnchor:self.snapshotButton.heightAnchor].active = YES;
//
//    NSDictionary *viewDict = @{@"previewView":self.previewView,
//                               @"captureView":self.captureImageView,
//                               @"snapshotButton":self.snapshotButton,
//                               @"addPhotoButton":self.addPhotoButton,
//                               @"view":self.view
//                               };
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[previewView]-8-[captureView]-8-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[captureView]-(>=8)-[snapshotButton]-(>=8)-[addPhotoButton]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewDict]];
}

// Sets all UI of the page
- (void) setMasterUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setViewsUI];
    [self initalizeButtons];
    [self setNavigationUI];
    [self setConstraints];
}

- (void) configureAVCapture {
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    else if (self.session && [self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    self.stillImageOutput = [AVCapturePhotoOutput new];
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    if (self.videoPreviewLayer) {
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.previewView.layer addSublayer:self.videoPreviewLayer];
        
        [self.session startRunning];
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *imageData = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *resizedImage = [self resizeImage:image withSize:CGSizeMake(82.6667*3, 147.333*3)];
    self.captureImageView.image = resizedImage;
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onTapAddPhoto:(id)sender {
    if (self.captureImageView.image) [self.delegate didTakePhoto:self.captureImageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onTapCapture:(id)sender {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];
    [self.stillImageOutput capturePhotoWithSettings:settings delegate:self];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

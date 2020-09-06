//
//  iOSCompanySDKViewController.m
//  iOSCompanySDK

#import "iOSCompanySDKViewController.h"

//#import <iOSCompanySDK/NPTSDKSystemMgr.h>


#import <iOSCompanySDK/AVSDKAssetAlphaJoinBgImgExportVideo.h>




@interface iOSCompanySDKViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation iOSCompanySDKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"点击" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    nextBtn.layer.borderColor = [UIColor redColor].CGColor;
    nextBtn.layer.borderWidth = 1.0;
    [self.view addSubview:nextBtn];
    nextBtn.frame = CGRectMake(50, 100, 80, 80);
    [nextBtn addTarget:self action:@selector(tapNextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - action
- (void)twotapNextBtnAction {
    [self selectAlbum];
    
}

#pragma mark - select Album + Delegate
- (void)selectAlbum {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES; //  allowsEditing属性⼀一定要设置成yes，表示照⽚片可编辑，会出现矩形图⽚片选择框
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (@available(iOS 13.0,*)) {
        imagePickerController.modalPresentationStyle =  UIModalPresentationFullScreen;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //退出相册
    [picker dismissViewControllerAnimated:YES completion:^{
        
        // 使用 - 原图
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 使⽤- 用户选择区域图⽚
        UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        // 得到图片后操作使用
        //self.bgCoverImg = editImage;
        
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *disPNGPath = [tmpDir stringByAppendingFormat:@"tmp-1.jpg"];
        //NSData *data = [NSData dataWithData:UIImagePNGRepresentation(editImage)];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(editImage, 0.5)];
        [data writeToFile:disPNGPath atomically:YES];
        
    }];
}


//
- (void)tapNextBtnAction {
    NSLog(@"log-开始制作");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exportVideoGetNotification) name:kAlphaVideoCombineImgFinishNotification object:nil];
    
    AVSDKAssetAlphaJoinBgImgExportVideo *exportMgr= [AVSDKAssetAlphaJoinBgImgExportVideo aVSDKAssetAlphaJoinBgImgExportVideo];
    
    NSString *rgbFilePath = [[NSBundle mainBundle]pathForResource:kVideoColorStr ofType:@""];
    NSString *alphaFilePath = [[NSBundle mainBundle]pathForResource:kVideoMaskStr ofType:@""];
    
    //NSString *tmpDir = NSTemporaryDirectory();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *tmpOutPath = [documentsDirectory stringByAppendingFormat:@"tmpOut.mp4"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:tmpOutPath]) {
        [fm removeItemAtPath:tmpOutPath error:nil];
    }
    UIImage *bgCoverImg = [UIImage imageNamed:@"tmp-1.jpg"];
    
    [exportMgr loadAVAnimationResourcesWithMovieRGBFilePath:rgbFilePath movieAlphaFilePath:alphaFilePath outPath:tmpOutPath bgCoverImg:bgCoverImg bgCoverImgPoint:CGPointMake(0, 301)];
    
}

- (void)exportVideoGetNotification {
    //
    NSLog(@"log-视频导出完成");
    self.view.backgroundColor = [UIColor redColor];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

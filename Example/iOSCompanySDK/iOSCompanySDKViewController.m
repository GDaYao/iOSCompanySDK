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
    //[self selectAlbum];
    
}

/*
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
        self.bgCoverImg = editImage;
        
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *disPNGPath = [tmpDir stringByAppendingFormat:@"tmp-1.jpg"];
        //NSData *data = [NSData dataWithData:UIImagePNGRepresentation(editImage)];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(editImage, 0.5)];
        [data writeToFile:disPNGPath atomically:YES];
        
    }];
}


//
- (void)tapNextBtnAction {

    
    AlphaVideoPlayExportViewController *nextAlphaPlayVC = [[AlphaVideoPlayExportViewController alloc]init];

    nextAlphaPlayVC.bgCoverImg = self.bgCoverImg;
    
    NSString *srcPath = [[NSBundle mainBundle]bundlePath];
    
    // 资源路径
    nextAlphaPlayVC.unzipVideoPath  = srcPath;  // ~/Documents/TempleDes/xxxx
    
    nextAlphaPlayVC.mvColorStr = [[NSBundle mainBundle]pathForResource:kVideoColorStr ofType:@""];
    nextAlphaPlayVC.mvMaskStr = [[NSBundle mainBundle]pathForResource:kVideoMaskStr ofType:@""];
    
    nextAlphaPlayVC.mvJsonPath = [[NSBundle mainBundle]pathForResource:kVideoJsonStr ofType:@""];
    
    nextAlphaPlayVC.fileName = @"chunnuanhuakai";
    
    
    
    [self.navigationController pushViewController:nextAlphaPlayVC animated:YES];
    
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

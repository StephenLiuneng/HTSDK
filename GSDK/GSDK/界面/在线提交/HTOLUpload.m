//
//  HTOLUpload.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTOLUpload.h"
#import "HTTextField.h"
#import "HTOLUPLoadCell.h"
#import "HTAlbumController.h"
#import "HTPhotosController.h"
@interface HTOLUpload ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView*topView;

@property (nonatomic,strong) HTBaseLabel*questionLabel;

@property (nonatomic,strong) UIImageView*xialaButton;

@property (nonatomic,strong) UITextView*textView;

@property (nonatomic,strong) HTBaseLabel*placeHolderLabel;

@property (nonatomic,strong) HTBaseButton*addImageButton;

@property (nonatomic,strong) NSMutableArray*imageArray;

@property (nonatomic,strong) HTTextField*emailTextField;

@property (nonatomic,strong) HTBaseButton*uploadButton;

@property (nonatomic,assign) BOOL showList;

@property (nonatomic,strong) UITableView*xialaTableView;

@property (nonatomic,strong) HTOLUPLoadCell*tempCell;

@property (nonatomic,strong) NSArray*questionArray;
@end
@implementation HTOLUpload
-(NSArray *)questionArray
{
    if (!_questionArray) {
        _questionArray=@[bendihua(@"遊戲類問題"),bendihua(@"活動類問題"),bendihua(@"充值類問題"),bendihua(@"賬號密碼類問題"),bendihua(@"建議類問題"),bendihua(@"其他問題")];
    }
    return _questionArray;
}
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showList=NO;
       
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(50/550.0*MAINVIEW_WIDTH, 17/550.0*MAINVIEW_WIDTH, 450/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH)];
    self.topView.backgroundColor=CGrayColor;
    [self.topView setCorner:4];
    [self addSubview:self.topView];
    
    self.questionLabel=[[HTBaseLabel alloc]init];
    self.questionLabel.frame=CGRectMake(15/550.0*MAINVIEW_WIDTH, 0, 370/550.0*MAINVIEW_WIDTH, self.topView.height);
    [self.questionLabel setText:bendihua(@"請選擇問題類型") font:MXSetSysFont(10) color:CTextGrayColor sizeToFit:NO];
    [self.topView addSubview:self.questionLabel];
    
    UIView*buttonView=[[UIView alloc]init];
    buttonView.backgroundColor=CGreenColor;
    buttonView.frame=CGRectMake(self.questionLabel.right, 0, self.topView.width-self.questionLabel.right, self.topView.height);
    [self.topView addSubview:buttonView];
    
    self.xialaButton=[[UIImageView alloc]init];
    self.xialaButton.image = imageNamed(@"箭头_2");
    self.xialaButton.bounds=CGRectMake(0, 0, 27/550.0*MAINVIEW_WIDTH, 17/550.0*MAINVIEW_WIDTH);
    self.xialaButton.center=CGPointMake(buttonView.width/2, buttonView.height/2);

    [buttonView addSubview:self.xialaButton];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xialaAction:)];
    [buttonView addGestureRecognizer:tap];
    
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(self.topView.left, self.topView.bottom+15/550.0*MAINVIEW_WIDTH, self.topView.width, 120/550.0*MAINVIEW_WIDTH)];
    self.textView.layer.borderColor=CRedColor.CGColor;
    self.textView.layer.borderWidth=1;
    [self addSubview:self.textView];
    self.placeHolderLabel=[[HTBaseLabel alloc]initWithFrame:CGRectMake(10/550.0*MAINVIEW_WIDTH,8 , self.textView.width, 0)];
    [self.placeHolderLabel setText:bendihua(@"請詳細描述您的問題,我們會盡快回復您!") font:MXSetSysFont(8) color:CTextGrayColor sizeToFit:YES];
    self.placeHolderLabel.numberOfLines=YES;
    [self.textView addSubview:self.placeHolderLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification  object:nil];
    
    
    self.addImageButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    self.addImageButton.frame=CGRectMake(self.textView.left, self.textView.bottom+15/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH);
    [self.addImageButton setImage:imageNamed(@"上传照片") forState:(UIControlStateNormal)];
    [self.addImageButton addTarget:self action:@selector(addImageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.addImageButton];
    
    self.emailTextField=[[HTTextField alloc]init];
    self.emailTextField.frame=CGRectMake(self.textView.left, self.addImageButton.bottom+20/550.0*MAINVIEW_WIDTH,self.topView.width, self.topView.height);
    self.emailTextField.placeholder=bendihua(@"請留下您的聯繫郵箱,方便我們與您取得聯繫!");
    [self addSubview:self.emailTextField];
    
    self.uploadButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    self.uploadButton.frame=CGRectMake(self.emailTextField.left, self.emailTextField.bottom+16/550.0*MAINVIEW_WIDTH, self.emailTextField.width, self.emailTextField.height);
    [self.uploadButton setTitle:bendihua(@"提交") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    [self addSubview:self.uploadButton];
    
}
-(void)addImageButtonAction:(HTBaseButton*)sender
{
    [self removeAllImage];
    HTAlbumController*con=[[HTAlbumController alloc]init];
    UINavigationController*navi=[[UINavigationController alloc]initWithRootViewController:con];
    [HTPhotosController sharePhotoController].backPhoyosBlock=^(NSMutableArray*photoArray){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageArray=photoArray;
            [self configPhotos];
        });
    };
    [[self viewController]presentViewController:navi animated:YES completion:nil];
}

-(void)configPhotos
{
    
 
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.textView.left+65/550.0*MAINVIEW_WIDTH*i, self.addImageButton.top, self.addImageButton.width, self.addImageButton.height)];
        imageView.image=self.imageArray[i];
        imageView.tag=200+i;
        [self addSubview:imageView];
    }
    self.addImageButton.left=self.textView.left+65/550.0*MAINVIEW_WIDTH*self.imageArray.count;
}
-(void)removeAllImage
{    for (int i=0; i<self.imageArray.count; i++) {

    UIImageView*image=[self viewWithTag:200+i];
    [image removeFromSuperview];
    }
    self.addImageButton.left=self.textView.left;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
   }


// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)textChange
{
    if (self.textView.hasText) {
        self.placeHolderLabel.text=nil;
    }else
    {
        self.placeHolderLabel.text=bendihua(@"請詳細描述您的問題,我們會盡快回復您!");
    }
    
}
-(void)xialaAction:(UIGestureRecognizer*)sender
{
    
    if (self.showList==YES) {
        [self hiddenTableView];
        self.showList=NO;
    }else{
        [self showTableView];
        self.showList=YES;
    }
}
-(void)showTableView
{
    __weak typeof (self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
    
        weakSelf.xialaTableView.height+=self.addImageButton.bottom-self.topView.bottom;
        weakSelf.xialaButton.transform=CGAffineTransformMakeRotation(M_PI);

        
    }];
    
}
-(void)hiddenTableView
{
    __weak typeof (self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xialaTableView.height=0;
        weakSelf.xialaButton.transform=CGAffineTransformMakeRotation(0);

    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTOLUPLoadCell*cell=[[HTOLUPLoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"upCell"];
    cell.leftLabel.text=self.questionArray[indexPath.row];
    

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topView.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tempCell.rightButton.image=imageNamed(@"选择_1");
    HTOLUPLoadCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.rightButton.image=imageNamed(@"选择_2");
    self.tempCell=cell;
    [self hiddenTableView];
    self.showList=!self.showList;
    
    self.questionLabel.text=cell.leftLabel.text;
}
-(UITableView *)xialaTableView
{
    if (!_xialaTableView) {
        _xialaTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.topView.left, self.topView.bottom, self.topView.width, 0)];
        _xialaTableView.delegate=self;
        _xialaTableView.dataSource=self;
    }
    _xialaTableView.backgroundColor=CGrayColor;
    [self addSubview:_xialaTableView];
    [_xialaTableView registerClass:[HTOLUPLoadCell class] forCellReuseIdentifier:@"upCell"];
    _xialaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _xialaTableView;
}
@end

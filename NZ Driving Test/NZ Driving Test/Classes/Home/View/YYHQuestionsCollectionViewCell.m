//
//  YYHQuestionsCollectionViewCell.m
//  Json转plist
//
//  Created by 姚懿恒 on 2017/5/11.
//  Copyright © 2017年 姚懿恒. All rights reserved.
//

#import "YYHQuestionsCollectionViewCell.h"
#import "YYHAnswerButton.h"
#import "YYHQuestionItem.h"
@interface YYHQuestionsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *questionView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *resultLable;

@property (weak, nonatomic) IBOutlet YYHAnswerButton *answerA;
@property (weak, nonatomic) IBOutlet YYHAnswerButton *answerB;

@property (weak, nonatomic) IBOutlet YYHAnswerButton *answerC;
@property (weak, nonatomic) IBOutlet YYHAnswerButton *answerD;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeButton;

@property (weak, nonatomic) IBOutlet UIStackView *StackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapBetween;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTop;

/** <#comments#>*/
@property (nonatomic, weak) YYHAnswerButton *selectedButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewDistance;

@end

@implementation YYHQuestionsCollectionViewCell

#pragma mark - -------lazy loading--------------

#pragma mark - -------buttonClick--------------
- (IBAction)colseButtonClick {
    YYHFunc
    [[NSNotificationCenter defaultCenter] postNotificationName:YYHTCloseButtonDidClicked object:nil];
}

- (IBAction)answerButtonClick:(YYHAnswerButton *)sender {



    self.selectedButton.selected = NO;

    sender.selected = YES;



    //按钮第二次点击时
    if (self.selectedButton == sender) {
        if (sender.tag == self.questionItem.CorrectAnswer.integerValue) {
            
            self.resultLable.text = nil;


            

            [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                self.resultLable.alpha = 1.0;


                self.resultLable.numberOfLines = 0;
                self.resultLable.text = @"好极了, 回答正确!";
                self.resultLable.alpha = 0;
                self.imageView.hidden = YES;
            } completion:^(BOOL finished) {
                self.imageView.hidden = NO;

            }];

        }
        else{
            
            self.resultLable.text = nil;
            self.resultLable.alpha = 1.0;

            //动画持续1s, 设置透明度为0, 并显示相应的字符串

            [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionShowHideTransitionViews animations:^{

                self.resultLable.numberOfLines = 0;
                self.resultLable.text = @"回答错误, 再试一次吧~";

                self.resultLable.alpha = 0;
                self.imageView.hidden = YES;
            } completion:^(BOOL finished) {
                self.imageView.hidden = NO;
            }];

            //不需要再这里进行判断, 在这里负责将每一个对象传递出去, 外界负责判断
            [[NSNotificationCenter defaultCenter] postNotificationName:YYHPassingWrongNotification object:self.questionItem];

            }
    }



    self.selectedButton = sender;




}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (iphone4) {

        self.questionLabel.font = [UIFont systemFontOfSize:12];

        self.distanceToTop.constant = 40;
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.indexLabel.font = [UIFont systemFontOfSize:11];

        self.topViewDistance.constant = 15;

    }
    if (iphone5) {

        self.questionLabel.font = [UIFont systemFontOfSize:14];



    }

    

    self.questionView.layer.masksToBounds = YES;
    self.questionView.layer.cornerRadius = YYHCornerRadius;
    self.questionLabel.yyh_centerY = self.questionView.center.y;

    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = YYHCornerRadius;
    //紫色
//    self.questionLabel.textColor = YYHColor(240, 89, 249);
//    绿色
//    self.questionLabel.textColor = YYHColor(38, 199, 111);
    self.questionLabel.textColor = YYHColor(44, 202, 235);
//    self.questionLabel.textColor = YYHRandomColor;

//    [self addTimer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeLabel:) name:YYHCountDownNotification object:nil];



}

//更改时间栏
- (void)changeTimeLabel: (NSNotification *)time{

    NSNumber *sec = time.userInfo[YYHcountDown];

    NSInteger second = [sec integerValue];


    self.timeLabel.text =  [NSString stringWithFormat:@"%02ld:%02ld", second / 60, second % 60];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //超出父控件也显示
    self.resultLable.clipsToBounds = NO;
    if (iphone4) {
        self.gapBetween.constant = 10;
        [self layoutIfNeeded];
    }
    if (iphone5) {
        self.gapBetween.constant = 20;
        [self layoutIfNeeded];
    }
}


/**
 设置模型数据
 */
-  (void)setQuestionItem:(YYHQuestionItem *)questionItem{
    _questionItem = questionItem;

    //每次传入模型时, 重新初始化子控件上的内容, 防止内容错乱显示
    [self initSubViewsContent];


    self.questionLabel.text = questionItem.Question;


    self.indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", questionItem.current.row + 1, (long)questionItem.total];


    if (questionItem.Image.length > 1) {
        NSString *path = [[NSBundle mainBundle] pathForResource:questionItem.Image ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];

        self.imageView.image = image;
    }else{
        self.imageView.image = nil;
    }

    
    if (questionItem.C.length < 1 ) {
        self.answerC.hidden = YES;
        self.answerD.hidden = YES;
    }
    else{
        self.answerC.hidden = NO;
        self.answerD.hidden = NO;

    }
    [self.answerA setTitle:questionItem.A forState:UIControlStateNormal];
    [self.answerB setTitle:questionItem.B forState:UIControlStateNormal];
    [self.answerC setTitle:questionItem.C forState:UIControlStateNormal];
    [self.answerD setTitle:questionItem.D forState:UIControlStateNormal];
}

- (void)initSubViewsContent{
    self.selectedButton.selected = NO;

    self.selectedButton = nil;
    self.resultLable.text = nil;
//    self.questionLabel.text = nil;
//    self.questionLabel.textAlignment = NSTextAlignmentCenter;
}
@end

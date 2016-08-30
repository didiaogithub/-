//
//  ViewController.m
//  EatDoudou
//
//  Created by 马军 on 16/8/28.
//  Copyright © 2016年 马军. All rights reserved.
//

#import "ViewController.h"

// 移动方向
typedef  enum {
    DirectionUp = 0,
    DirectionLeft,
    DirectionRight,
    DirectionDown
}MoveDirection;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView; // 后面绿色背景的View
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel; // 分数
@property (nonatomic, weak) UIImageView *eat;  // 嘴巴的视图
@property (nonatomic, assign) CGFloat  speed; // 移动速度
@property (weak, nonatomic) UIImageView *doudou; // 小豆子
@property (weak, nonatomic) NSTimer * timer;//定时器
@property (assign, nonatomic)MoveDirection direction; // 移动方向

@end

@implementation ViewController


// lazy加载eat视图
-(UIImageView *)eat{
    if (!_eat) {
        
        // 确保eat视图第一次出现时不会在边缘
        CGFloat  x = arc4random() % (int)(self.backgroundView.bounds.size.width - 200) + 100;
        CGFloat  y = arc4random() % (int)(self.backgroundView.bounds.size.height - 200) + 100;
        // 添加到父控件
        int index = arc4random() % 5;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 50, 50)];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",index]];
        [self.backgroundView addSubview:imageV];
        _eat = imageV;
    }
    return _eat;
}

// lazy加载豆豆视图
- (UIImageView *)doudou{
    
    
    if (!_doudou) {
        
        // 确保doudou视图第一次出现时不会在边缘
        
        CGFloat   x = arc4random() % (int)(self.backgroundView.bounds.size.width - 100) + 50;
        CGFloat   y = arc4random() % (int)(self.backgroundView.bounds.size.height - 100) + 50;
        // 添加到父控件
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
        imageV.image = [UIImage imageNamed:@"15"];
        [self.backgroundView addSubview:imageV];
        _doudou = imageV;
    }
    return _doudou;
}


// lazy加载定时器
- (NSTimer *)timer{
    if (!_timer) {
     
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

// 游戏开始
- (IBAction)start {
    self.speed = 3;
    // 当豆豆和eat视图相交时，重新设置位置
    while (CGRectContainsRect(self.eat.layer.frame, self.doudou.frame)) {
        [self.doudou removeFromSuperview];
        self.doudou;
    };
    [self.timer fire];
    //初始分数为0
    self.scoreLabel.text = @"Score : 000";
}

- (void)result{
    
    // eat 和 doudou 相交，分数 ＋ 100
    if (CGRectIntersectsRect(self.eat.frame, self.doudou.frame)) {
        // 移除原来的豆豆
        [self.doudou removeFromSuperview];
        
        self.speed += 1;
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d",(int)(self.speed - 3) * 100];
        // 添加新的豆豆
        self.doudou;
    }
    
    // 超出边界，游戏结束
    if (CGRectGetMaxX(self.eat.frame) > self.backgroundView.bounds.size.width ||CGRectGetMaxY(self.eat.frame) > self.backgroundView.bounds.size.height  || CGRectGetMaxX(self.eat.frame) < 0 || CGRectGetMaxY(self.eat.frame) < 0){
        
        [self.timer invalidate];
        [self.eat removeFromSuperview];
        
        // game over 提示框
        UILabel *deathTip = [[UILabel alloc]init];
        deathTip.text = @"Game Over";
        deathTip.backgroundColor = [UIColor whiteColor];
        [deathTip sizeToFit];
        [self.backgroundView addSubview:deathTip];
        deathTip.center = self.backgroundView.center;
        
        [UIView animateWithDuration:4.0 animations:^{
            deathTip.alpha = 0.0;
        }completion:^(BOOL finished) {
            [deathTip removeFromSuperview];
        }];
    }
}


// 移除动画
- (void)moveAnimation{
    
    CGPoint center = self.eat.center;
    
    switch (self.direction) {
        case DirectionUp:{
            self.eat.image = [UIImage imageNamed:@"13.png"];
            [UIView animateWithDuration:0.05 animations:^{
                self.eat.center = CGPointMake(center.x, center.y - self.speed);
            }];
            [self result];
        }
            break;
        case DirectionLeft:{
            self.eat.image = [UIImage imageNamed:@"12.png"];
            [UIView animateWithDuration:0.05 animations:^{
                self.eat.center = CGPointMake(center.x - self.speed, center.y);
            }];
            [self result];
        }
            break;
        case DirectionDown:{
            self.eat.image = [UIImage imageNamed:@"14.png"];
            [UIView animateWithDuration:0.05 animations:^{
                self.eat.center = CGPointMake(center.x, center.y + self.speed);
            }];
            [self result];
        }
            break;
        case DirectionRight:{
            self.eat.image = [UIImage imageNamed:@"11.png"];
            [UIView animateWithDuration:0.05 animations:^{
                self.eat.center = CGPointMake(center.x + self.speed, center.y);
            }];
            [self result];
        }
            break;
            
        default:
            break;
    }
}


// 移动方向按钮的点击
- (IBAction)moveClick:(UIButton *)sender {
    
    if (sender.tag == 1) {
        self.direction = DirectionLeft;
    }else if (sender.tag == 2){
        self.direction = DirectionUp;
    }else if (sender.tag == 3){
        self.direction = DirectionDown;
    }else if (sender.tag == 4){
        self.direction = DirectionRight;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

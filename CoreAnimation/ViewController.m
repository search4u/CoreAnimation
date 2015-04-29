//
//  ViewController.m
//  CoreAnimation
//
//  Created by bottle on 15-4-29.
//  Copyright (c) 2015年 bottle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,assign) int  index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self animationGroup];
}

#pragma mark - CABaseAnimation
/**
 *  旋转
 */
- (void)rotate {
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    //anim.fromValue = @(M_PI_4);
    anim.toValue  = @(M_PI * 2);
    anim.duration = 1;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.iconView.layer addAnimation:anim forKey:nil];
}

/**
 *  平移
 */
- (void)tanslate {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.delegate = self;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    anim.duration = 2;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.iconView.layer addAnimation:anim forKey:nil];
}

/**
 *  动画代理方法
 */
- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"animationDidStart-----");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStop-----");
}

#pragma mark - CAKeyframeAnimation
/**
 *  shake 晃动
 */
#define angle2radian(x) ((x) / 180.0 * M_PI)
- (void)shake {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.delegate = self;
    float angle = angle2radian(3);
    anim.values = @[@(angle),@(-angle),@(angle)];
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.1;
    [self.iconView.layer addAnimation:anim forKey:nil];
}

/**
 *  平移
 */
- (void)translate {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(0, 300)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    NSValue *v4 = [NSValue valueWithCGPoint:CGPointMake(300, 0)];
    anim.values = @[v1,v2,v3,v4];
    anim.duration = 2.0;
    CAMediaTimingFunction *t1 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *t2 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *t3 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //CAMediaTimingFunction *t4 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.timingFunctions = @[t1,t2,t3];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.iconView.layer addAnimation:anim forKey:nil];
}

- (void)translate2 {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path  = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 300, 300));
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 2;
    anim.path = path;
    anim.repeatCount = MAXFLOAT;
    [self.iconView.layer addAnimation:anim forKey:nil];
    CGPathRelease(path);
}

#pragma mark - CATransition 转场动画
- (void)transition {
    if (++self.index >= 9) {
        self.index = 0;
    }
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.index +1]];
    CATransition *anim = [CATransition animation];
    anim.duration = 0.5	;
    anim.type = @"cube";
    anim.subtype = @"fromRight";
    [self.imageView.layer addAnimation:anim forKey:nil];
}

#pragma mark - CAAnimationGroup
- (void)animationGroup {
    //动画1，平移
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(50, 500)];
    //动画2，旋转
    CAKeyframeAnimation *anim2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim2.values = @[@(0),@(M_PI*2),@(0)];
    //动画3，缩放
    CAKeyframeAnimation *anim3 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim3.values = @[@(0.0),@(1),@(0.0)];
    
    //添加到组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anim,anim2,anim3];
    group.repeatCount = MAXFLOAT;
    group.duration = 4.0;
    [self.iconView.layer addAnimation:group forKey:nil];
}
@end

//
//  WDSwipButton.m
//  WDSwipButton
//
//  Created by 吴迪玮 on 16/2/17.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import "WDSwipButton.h"

@interface WDSwipButton()

@property(nonatomic,assign)CGFloat factor;

@end

@implementation WDSwipButton{
    
    UIBezierPath *cutePath;
    UIColor *fillColorForCute;
    UIDynamicAnimator *animator;
    UISnapBehavior  *snap;
    
    UIView *backView;
    CGFloat r1;
    CGFloat r2;
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint initialPoint;
    CGPoint oldBackViewCenter;
    CAShapeLayer *shapeLayer;
    
    CGPoint _lastDragPoint;
}

-(void)awakeFromNib{
    [self setUp];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        initialPoint = CGPointMake(0, 0);
        _bubbleWidth = CGRectGetWidth(frame);
        _lastDragPoint = CGPointZero;
        [self setUp];
    }
    return self;
}

-(void)displayLinkAction{
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    
    r1 = oldBackViewFrame.size.width / 2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    [self drawRect];
}

-(void)drawRect{
    backView.center = oldBackViewCenter;
    backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
    backView.layer.cornerRadius = r1;
    
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    if (backView.hidden == NO) {
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColorForCute CGColor];
        [self.layer insertSublayer:shapeLayer below:self.frontView.layer];
    }
    
}

-(void)setUp{
    shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor clearColor];
    self.frontView = [[UIView alloc]initWithFrame:CGRectMake(initialPoint.x,initialPoint.y, self.bubbleWidth, self.bubbleWidth)];
    
    r2 = self.frontView.bounds.size.width / 2;
    self.frontView.layer.cornerRadius = r2;
    self.frontView.backgroundColor = self.swipColor;
    
    backView = [[UIView alloc]initWithFrame:self.frontView.frame];
    r1 = backView.bounds.size.width / 2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = self.swipColor;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.frontView insertSubview:self.titleLabel atIndex:0];
    
    [self addSubview:backView];
    [self addSubview:self.frontView];
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);   // O
    pointP = CGPointMake(x2+r2, y2);  // P
    
    oldBackViewFrame = backView.frame;
    oldBackViewCenter = backView.center;
    
    backView.hidden = YES;//为了看到frontView的气泡晃动效果，需要展示隐藏backView
    [self AddAniamtionLikeGameCenterBubble];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDragGesture:)];
    [self.frontView addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchGesture:)];
    [self.frontView addGestureRecognizer:tap];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}

#pragma mark -- UITapGestureRecognizer tapAction

-(void)handleTouchGesture:(UITapGestureRecognizer *)ges{
    if (r1 <= 6) {
        self.isSwipOut = NO;
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frontView.center = oldBackViewCenter;
            self.titleLabel.text = self.normalTitle;
        } completion:^(BOOL finished) {
            if (finished) {
                [self displayLinkAction];
                [self AddAniamtionLikeGameCenterBubble];
            }
        }];
    }
}

-(void)handleDragGesture:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self];
    if (self.isSwipOut) {
        return;
    }
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        backView.hidden = NO;
        fillColorForCute = self.swipColor;
        [self RemoveAniamtionLikeGameCenterBubble];
    }else if (ges.state == UIGestureRecognizerStateChanged){
        if (dragPoint.y <= _lastDragPoint.y) {
            return;
        }
        _lastDragPoint = dragPoint;
        self.frontView.center = dragPoint;
        if (r1 <= 6) {
            fillColorForCute = [UIColor clearColor];
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
        }
        [self displayLinkAction];
    } else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        backView.hidden = YES;
        fillColorForCute = [UIColor clearColor];
        [shapeLayer removeFromSuperlayer];
        _lastDragPoint = CGPointZero;
        if (r1 <= 6) {
            self.isSwipOut = YES;
            [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.frontView.center = CGPointMake(oldBackViewCenter.x, oldBackViewCenter.y + 100);
                self.titleLabel.text = self.swipOutTitle;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self AddAniamtionLikeGameCenterBubble];
                }
            }];
        } else {
            [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.frontView.center = oldBackViewCenter;
                self.titleLabel.text = self.normalTitle;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self AddAniamtionLikeGameCenterBubble];
                }
            }];
        }
    }
    
}


//---- 类似GameCenter的气泡晃动动画 ------

-(void)AddAniamtionLikeGameCenterBubble{
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontView.frame, self.frontView.bounds.size.width / 2 - 3, self.frontView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

-(void)RemoveAniamtionLikeGameCenterBubble{
    [self.frontView.layer removeAllAnimations];
}

#pragma mark - getter & setter
-(UIColor *)swipColor{
    if (!_swipColor) {
        _swipColor = [UIColor redColor];
    }
    
    return _swipColor;
}

-(CGFloat)viscosity{
    if (!_viscosity) {
        _viscosity = 3;
    }
    return _viscosity;
}

-(CGFloat)bubbleWidth{
    if (!_bubbleWidth) {
        _bubbleWidth = 35;
    }
    return _bubbleWidth;
}

-(void)setNormalTitle:(NSString *)normalTitle{
    _normalTitle = normalTitle;
    if (r1 > 6) {
        self.titleLabel.text = normalTitle;
    }
}

-(void)setSwipOutTitle:(NSString *)swipOutTitle{
    _swipOutTitle = swipOutTitle;
    if (r1 <= 6) {
        self.titleLabel.text = swipOutTitle;
    }
}

@end

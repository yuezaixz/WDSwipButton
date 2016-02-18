//
//  WDSwipButton.h
//  WDSwipButton
//
//  Created by 吴迪玮 on 16/2/17.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SwipDirection {
    SwipDirectionNone,
    SwipDirectionRight,
    SwipDirectionLeft,
    SwipDirectionUp,
    SwipDirectionDown,
    SwipDirectionCrazy,
} SwipDirection;

@protocol WDSwipButtonDelegate <NSObject>

- (void)swipOut;
- (void)swipBack;

@end

@interface WDSwipButton : UIView

@property (weak, nonatomic) id<WDSwipButtonDelegate> delegate;

@property (nonatomic,assign)CGFloat bubbleWidth;//直径
@property (nonatomic,assign)CGFloat viscosity;//黏性
@property (nonatomic,strong)UIColor *swipColor;
@property (nonatomic,strong)UIView *frontView;

@property (nonatomic) BOOL isSwipOut;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSString *normalTitle;
@property (strong, nonatomic) NSString *swipOutTitle;

-(void)setUp;

@end

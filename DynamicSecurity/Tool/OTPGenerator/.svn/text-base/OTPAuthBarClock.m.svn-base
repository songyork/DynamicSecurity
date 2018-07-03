//
//  OTPAuthBarClock.m
//
//  Copyright 2011 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "OTPAuthBarClock.h"
//#import "GTMDefines.h"
#import "ZZCACircleProgress.h"


#define Weak_Self __weak typeof(self) weakSelf = self
//角度转换为弧度
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0
//255进制颜色转换
#define CircleRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//宽高定义
#define CircleSelfWidth self.frame.size.width
#define CircleSelfHeight self.frame.size.height
#define SongYRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface OTPAuthBarClock ()
{
    CGFloat fakeProgress;
    ZZCACircleProgress *cirPro;
}
@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (nonatomic, assign, readwrite) NSTimeInterval period;
@property (nonatomic, assign) int currentTime;
- (void)startUpTimer;
@end

@implementation OTPAuthBarClock

@synthesize timer = timer_;
@synthesize period = period_;

- (id)initWithFrame:(CGRect)frame period:(NSTimeInterval)period {
  if ((self = [super initWithFrame:frame])) {
    [self startUpTimer];
    self.opaque = NO;
    self.period = period;
      self.currentTime = 0;
    UIApplication *app = [UIApplication sharedApplication];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(applicationDidBecomeActive:)
               name:UIApplicationDidBecomeActiveNotification
             object:app];
    [nc addObserver:self
           selector:@selector(applicationWillResignActive:)
               name:UIApplicationWillResignActiveNotification
             object:app];
      NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
      NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"ZZCircleProgress" ofType:@"bundle"]];
      _pointImage = [UIImage imageNamed:@"circle_point1" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
//    cirPro = [[ZZCACircleProgress alloc] initWithFrame:frame pathBackColor:nil pathFillColor:SongYRGB(arc4random()%255, arc4random()%255, arc4random()%255) startAngle:-90 strokeWidth:10];
      cirPro.center = self.center;
      cirPro.increaseFromLast = YES;
      [self addSubview:cirPro];
  }
  return self;
}

//初始化数据
- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    _pathBackColor = CircleRGB(204, 204, 204);
    _pathFillColor = CircleRGB(219, 184, 102);
    _strokeWidth = 10;//线宽默认为10
    _startAngle = -CircleDegreeToRadian(90);//圆起点位置
    _reduceAngle = CircleDegreeToRadian(0);//整个圆缺少的角度
    _showPoint = YES;//小圆点
    _showProgressText = YES;//文字
    _forceRefresh = NO;//一直刷新动画
    
    fakeProgress = 0.0;//用来逐渐增加直到等于progress的值
    //获取图片资源
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"ZZCircleProgress" ofType:@"bundle"]];
    _pointImage = [UIImage imageNamed:@"circle_point1" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
}


- (void)dealloc {
//  _GTMDevAssert(!self.timer, @"Need to call invalidate on clock!");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
//  [super dealloc];
}

- (void)redrawTimer:(NSTimer *)timer {
    Weak_Self;
    _currentTime++;
    if (_currentTime == 30) {
        _currentTime = 0;
        if (weakSelf.clockBlock) {
            weakSelf.clockBlock();
        }
    }
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    CGFloat mod =  fmod(seconds, self.period);
    CGFloat percent = mod / self.period;
    NSLog(@"------------%f", percent);
    cirPro.progress = (mod / self.period);
    [cirPro.progressLayer removeAllAnimations];


    
        /*
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
//        CGFloat radius = maxWidth/2.0-10/2.0-1;//留出一像素，防止与边界相切的地方被切平


    CGRect bounds = self.bounds;
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, rect);
    CGFloat midX = CGRectGetMidX(bounds);
    CGFloat midY = CGRectGetMidY(bounds);
    CGFloat radius = midY - 4;

    CGContextMoveToPoint(context, midX, midY);
    CGFloat start = -M_PI_2;
    CGFloat end = 2 * M_PI;

    CGFloat sweep = end * percent + start;
    CGContextAddArc(context, midX, midY, radius, start, sweep, 1);
    [[UIColor whiteColor] setFill];
    CGContextFillPath(context);
    if (percent > .875) {
    CGContextMoveToPoint(context, midX, midY);
    CGContextAddArc(context, midX, midY, radius, start, sweep, 1);
    CGFloat alpha = (percent - .875) / .125;
    [[[UIColor clearColor] colorWithAlphaComponent:alpha * 0.5] setFill];
    CGContextFillPath(context);
    }

        
        //背景线
        UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
        //线条宽度
        CGContextSetLineWidth(context, 5);
        //设置线条顶端
        CGContextSetLineCap(context, kCGLineCapRound);
        //线条颜色
        [[UIColor lightGrayColor] setStroke];
        //把路径添加到上下文
        CGContextAddPath(context, basePath.CGPath);
        //渲染背景线
        CGContextStrokePath(context);
        
//    // Draw top shadow
    CGFloat offset = 0.25;
    CGFloat x = midX + (radius - offset) * cos(0 - M_PI_4);
    CGFloat y = midY + (radius - offset) * sin(0 - M_PI_4);
    [[UIColor blackColor] setStroke];
    CGContextMoveToPoint(context, x , y);
    CGContextAddArc(context,
                  midX, midY, radius - offset, 0 - M_PI_4, 5.0 * M_PI_4, 1);
    CGContextStrokePath(context);

    // Draw bottom highlight
    x = midX + (radius + offset) * cos(0 + M_PI_4);
    y = midY + (radius + offset) * sin(0 + M_PI_4);
    [[UIColor whiteColor] setStroke];
    CGContextMoveToPoint(context, x , y);
//        CGContextAddArc(<#CGContextRef  _Nullable c#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat radius#>, <#CGFloat startAngle#>, <#CGFloat endAngle#>, <#int clockwise#>)
    CGContextAddArc(context, midX, midY, radius + offset, 0 + M_PI_4, 4.0 * M_PI_4, 0);
    CGContextStrokePath(context);

    // Draw face
    [[UIColor cyanColor] setStroke];
    CGContextMoveToPoint(context, midX + radius , midY);
    CGContextAddArc(context, midX, midY, radius, 0, 2.0 * M_PI, 0);
    CGContextStrokePath(context);

    if (percent > .875) {
        CGFloat alpha = (percent - .875) / .125;
        [[[UIColor redColor] colorWithAlphaComponent:alpha] setStroke];
        CGContextStrokePath(context);
    }

    // Hand
    x = midX + radius * cos(sweep);
    y = midY + radius * sin(sweep);
    CGContextMoveToPoint(context, midX, midY);
    CGContextAddLineToPoint(context, x, y);
    CGContextStrokePath(context);
        */
}

- (void)invalidate {
  [self.timer invalidate];
  self.timer = nil;
}

- (void)startUpTimer {
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                target:self
                                              selector:@selector(redrawTimer:)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [self startUpTimer];
  [self redrawTimer:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [self invalidate];
}

@end

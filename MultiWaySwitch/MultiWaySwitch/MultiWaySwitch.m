//
//  MultiWaySwitch.m
//  MultiWaySwitch.git
//
//  Created by Zensis on 15/4/15.
//  Copyright (c) 2015 David. All rights reserved.
//

#import "MultiWaySwitch.h"

@implementation MultiWaySwitch{
    CGPoint currentThumbPoint;
    Boolean isTouching;
    int lastPosition;
    UIImageView * thumb;
}


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.numberOfPoints = 2;
        self.trackWidth = 20.0;
        self.trackColor = [UIColor lightGrayColor];
        self.showGap = YES;
        self.gapWidth = 5.0;
        self.thumbHeight = 40;
        self.thumbWidth = 40;
        thumb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.thumbWidth,   self.thumbHeight)];
        [self addSubview:thumb];
        isTouching = NO;
        lastPosition = -1;
        [self setBackgroundColor: [UIColor clearColor]];
    }
    
    return self;
}

#pragma mark - UIControl Override -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint( thumb.frame, touchPoint)){
        isTouching = YES;
        return YES;
    }
    else{
        isTouching = NO;
        return NO;
    }
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint = [touch locationInView:self];
    [self movehandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    isTouching = NO;
    [self setNeedsDisplay];
}

#pragma mark - Drawing Functions -

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw track
    [self.trackColor setStroke];
    CGContextSetLineWidth(context,self.trackWidth);
    CGContextMoveToPoint(context,0, self.frame.size.height/2);
    CGContextAddLineToPoint(context,self.frame.size.width, self.frame.size.height/2);
    CGContextStrokePath(context);
    
    //make the track rounded
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextSetLineWidth(context, self.trackWidth);
    
    CGContextMoveToPoint(context, -self.trackWidth/4, self.frame.size.height/2);
    CGContextAddArcToPoint(context, -self.trackWidth/4, (self.trackWidth)+self.frame.size.height/2, 0, (self.trackWidth)+self.frame.size.height/2, self.trackWidth);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, -self.trackWidth/4, self.frame.size.height/2);
    CGContextAddArcToPoint(context, -self.trackWidth/4, -(self.trackWidth)+self.frame.size.height/2, 0, -(self.trackWidth)+self.frame.size.height/2, self.trackWidth);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.frame.size.width+self.trackWidth/4, self.frame.size.height/2);
    CGContextAddArcToPoint(context,self.frame.size.width+self.trackWidth/4, (self.trackWidth)+self.frame.size.height/2, 0, (self.trackWidth)+self.frame.size.height/2, self.trackWidth);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.frame.size.width+self.trackWidth/4, self.frame.size.height/2);
    CGContextAddArcToPoint(context,self.frame.size.width+self.trackWidth/4, -(self.trackWidth)+self.frame.size.height/2, 0, -(self.trackWidth)+self.frame.size.height/2, self.trackWidth);
    CGContextStrokePath(context);
    
    //draw gaps
    if(self.showGap){
        for(int i=1; i<self.numberOfPoints+1; i++){
            CGContextSetLineWidth(context, self.trackWidth);
            CGContextMoveToPoint(context, i*self.frame.size.width/(self.numberOfPoints+1), self.frame.size.height/2);
            CGContextAddLineToPoint(context, self.gapWidth+i*self.frame.size.width/(self.numberOfPoints+1), self.frame.size.height/2);
            CGContextStrokePath(context);
        }
    }
    
    //draw thumb
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    int position = (currentThumbPoint.x + 0.5*self.frame.size.width/(self.numberOfPoints+1))/ (self.frame.size.width/(self.numberOfPoints+1));
    if(position != 0)
        position--;
    if (position == self.numberOfPoints)
        position--;
    
    if(lastPosition != position){
        if(self.thumbImages != nil){
            [UIView transitionWithView:thumb
                              duration:0.08f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                thumb.image = [self.thumbImages objectAtIndex:position];
                            } completion:NULL];
        }
        else{
            [thumb setImage:[UIImage imageNamed:@"thumba.jpg"]];
        }
        if(self.delegate !=nil) [self.delegate switchedTo: position];
        lastPosition = position;
    }
    if(isTouching){
        thumb.frame = CGRectMake(- self.thumbWidth/2+currentThumbPoint.x, -self.thumbHeight/2+currentThumbPoint.y, self.thumbWidth, self.thumbHeight);
        thumb.alpha = 0.5;
        
    }
    else{
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             thumb.frame = CGRectMake(-self.thumbWidth/2 + self.gapWidth/2 +(position+1)*self.frame.size.width/(self.numberOfPoints+1), -self.thumbHeight/2+self.frame.size.height/2, self.thumbWidth, self.thumbHeight);
                             thumb.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             if(self.delegate!=nil)
                                 [self.delegate stopedAt:lastPosition];
                         }];
        
    }
    
}

-(void)movehandle:(CGPoint)lastPoint{
    if(lastPoint.x <10) lastPoint.x = 10;
    else if(lastPoint.x >self.frame.size.width-10) lastPoint.x = self.frame.size.width-10;
    currentThumbPoint = CGPointMake(lastPoint.x, self.frame.size.height/2);
    [self setNeedsDisplay];
}

@end

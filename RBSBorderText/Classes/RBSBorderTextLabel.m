//
//  RBSBorderTextLabel.m
//  RBSBorderText
//
//  Created by Snow.y.wu on 4/25/19.
//

#import "RBSBorderTextLabel.h"
#import "RBSBorderTextLayoutManager.h"

@implementation RBSBorderTextLabel
{
    NSTextContainer *_rbsTextContainer;
    NSTextStorage *_rbsTextStorage;
    RBSBorderTextLayoutManager *_rbsLayoutManager;
}

#pragma mark    -   Accessors
- (NSTextContainer *)textContainer {
    return _rbsTextContainer;
}

- (NSTextStorage *)textStorage {
    return _rbsTextStorage;
}

- (RBSBorderTextLayoutManager *)layoutManager {
    return _rbsLayoutManager;
}

#pragma mark    -   Super


#pragma mark        View lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return CGSizeZero;
    }
    
    self.textContainer.maximumNumberOfLines = (NSUInteger)self.numberOfLines;
    self.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textContainer.lineFragmentPadding = 0.0;
    self.textContainer.size = CGSizeMake(size.width, FLT_MAX);
    
    [self.textContainer.layoutManager glyphRangeForTextContainer:self.textContainer];
    
    return [self.textContainer.layoutManager usedRectForTextContainer:self.textContainer].size;
}

- (void)drawTextInRect:(CGRect)rect {
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return;
    }
    
    [super drawTextInRect:rect];
    [self.layoutManager drawInRect:rect];
}

#pragma mark        Object lifecycle


#pragma mark    -   Actions

#pragma mark    -   Interface

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer {
    self = [self initWithFrame:frame];
    if (self) {
        
        RBSBorderTextLayoutManager *tmpLayoutManager = nil;//reduce the layout init. inner make tree.
        NSTextContainer *tmpTextContainer = nil;
        
        if (textContainer) {
            
            //Only support RBSBorderTextLayoutManager
            if (textContainer.layoutManager == nil || ![textContainer.layoutManager isKindOfClass:[RBSBorderTextLayoutManager class]] ) {
                tmpLayoutManager = [[RBSBorderTextLayoutManager alloc] init];
                [tmpLayoutManager addTextContainer:textContainer];
            }
            tmpTextContainer = textContainer;
            
        } else {
            
            tmpLayoutManager = [[RBSBorderTextLayoutManager alloc] init];
            tmpTextContainer = [[NSTextContainer alloc] initWithSize:frame.size];
            [tmpLayoutManager addTextContainer:tmpTextContainer];
        }
        
        NSTextStorage *tmpTextStorage = [[NSTextStorage alloc] init];
        [tmpTextStorage addLayoutManager:tmpLayoutManager];
        
        
        _rbsTextStorage = tmpTextStorage;
        _rbsLayoutManager = tmpLayoutManager;
        _rbsTextContainer = tmpTextContainer;
        
    }
    return self;
}

#pragma mark    -   Private
#pragma mark Extract Function

#pragma mark Extract Method


#pragma mark    -   Protocol


@end

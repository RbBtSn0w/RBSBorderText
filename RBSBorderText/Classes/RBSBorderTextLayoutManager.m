//
//  RBSBorderTextLayoutManager.m
//  RBSBorderText
//
//  Created by Snow.y.wu on 4/25/19.
//

#import "RBSBorderTextLayoutManager.h"
#import "RBSBorderTextStyle.h"


@implementation RBSBorderTextLayoutManager


#pragma mark    -   Accessors


#pragma mark    -   Super

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    //NSLog(@"[TextLayout] drawBackgroundForGlyphRange %@", NSStringFromRange(glyphsToShow));
    
    [self enumerateLineFragmentsForGlyphRange:glyphsToShow usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRangeByFilter, BOOL * _Nonnull stop) {
        
        //NSLog(@"[TextLayout] enumerateLineFragmentsForGlyphRange rect:%@, usedRect:%@", NSStringFromCGRect(rect), NSStringFromCGRect(rect));
        
        //NSLog(@"[TextLayout] begin glyphRange %@", NSStringFromRange(glyphRangeByFilter));
        //find underline on the border frame
        while (glyphRangeByFilter.length > 0) {
            NSRange charRange = [self characterRangeForGlyphRange:glyphRangeByFilter actualGlyphRange:nil];
            NSRange attributeCharRange;
            NSRange attributeGlyphRange;
            
            id attribute = [self.textStorage attribute:RBSBorderTextStyleAttributeName
                                               atIndex:charRange.location longestEffectiveRange:&attributeCharRange
                                               inRange:charRange];
            attributeGlyphRange = [self glyphRangeForCharacterRange:attributeCharRange actualCharacterRange:NULL];
            attributeGlyphRange = NSIntersectionRange(attributeGlyphRange, glyphRangeByFilter);
            if( attribute != nil ) {
                //find it
                
                RBSBorderTextStyle *borderTextStyle = attribute;
                
                CGRect boundingRect = [self boundingRectForGlyphRange:attributeGlyphRange inTextContainer:textContainer];
                [self drawBorder:boundingRect withFill:borderTextStyle.fillColorOnBackground byColor:borderTextStyle.color];
                
                //NSLog(@"[TextLayout] attributeGlyphRange %@, origin:%@ boundingRect:%@", NSStringFromRange(attributeGlyphRange), NSStringFromCGPoint(origin), NSStringFromCGRect(boundingRect));
            }
            glyphRangeByFilter.length = NSMaxRange(glyphRangeByFilter) - NSMaxRange(attributeGlyphRange);
            glyphRangeByFilter.location = NSMaxRange(attributeGlyphRange);
            
        }
    }];
    
    
    //NSLog(@"[TextLayout] end Search");
}


#pragma mark        Object lifecycle


#pragma mark    -   Actions

#pragma mark    -   Interface
- (void)drawInRect:(CGRect)rect {
    
    NSUInteger length = self.textStorage.length;
    
    [self invalidateGlyphMappings];
    [self forceLayout];
    
    if (length <= 0) {
        return;
    }
    
    NSRange glyphRange = NSMakeRange(0, self.textStorage.length);
    [self drawBackgroundForGlyphRange:glyphRange atPoint:rect.origin];
    [self drawGlyphsForGlyphRange:glyphRange atPoint:rect.origin];
}

#pragma mark    -   Private
#pragma mark Extract Function

#pragma mark Extract Method
- (void)invalidateGlyphMappings {
    [self invalidateGlyphsForCharacterRange:(NSRange){0, self.textStorage.length } changeInLength:0 actualCharacterRange:NULL];
}

- (void)forceLayout {
    [self ensureLayoutForCharacterRange:(NSRange){ 0, self.textStorage.length }];
}

- (void)drawBorder:(CGRect)borderFrame withFill:(BOOL)fill byColor:(UIColor*)color {
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRoundedRect:borderFrame cornerRadius:100];
    [bezierPath closePath];
    bezierPath.usesEvenOddFillRule = YES;
    if (fill) {
        [color setFill];
        [bezierPath fill];
    } else {
        [color setStroke];
        [bezierPath stroke];
    }
}


#pragma mark    -   Protocol


@end

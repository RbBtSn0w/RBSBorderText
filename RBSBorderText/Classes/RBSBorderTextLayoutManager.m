//
//  RBSBorderTextLayoutManager.m
//  RBSBorderText
//
//  Created by Snow.y.wu on 4/25/19.
//

#import "RBSBorderTextLayoutManager.h"
#import "RBSBorderTextStyle.h"

#if RBSLogEnable
#define RBSLOG(frmt, ...) NSLog(@"%@",[NSString stringWithFormat:frmt, ##__VA_ARGS__]);
#else
#define RBSLOG(frmt, ...)
#endif



@implementation RBSBorderTextLayoutManager


#pragma mark    -   Accessors


#pragma mark    -   Super

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    RBSLOG(@"[TextLayout] drawBackgroundForGlyphRange:%@ origin:%@", NSStringFromRange(glyphsToShow),NSStringFromCGPoint(origin));
    
    [self enumerateLineFragmentsForGlyphRange:glyphsToShow usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange lineGlyphRange, BOOL * _Nonnull stop) {
        
        RBSLOG(@"[TextLayout] enumerateLineFragmentsForGlyphRange rect:%@, usedRect:%@", NSStringFromCGRect(rect), NSStringFromCGRect(usedRect));
        
        RBSLOG(@"[TextLayout] line glyphRange %@", NSStringFromRange(lineGlyphRange));
        //find underline on the border frame
        while (lineGlyphRange.length > 0) {
            NSRange charRange = [self characterRangeForGlyphRange:lineGlyphRange actualGlyphRange:nil];
            NSRange attributeCharRange;
            NSRange attributeGlyphRange;
        
            RBSLOG(@"[TextLayout] charRange:%@", NSStringFromRange(charRange));
            id attribute = [self.textStorage attribute:RBSBorderTextStyleAttributeName
                                               atIndex:charRange.location longestEffectiveRange:&attributeCharRange
                                               inRange:charRange];
            RBSLOG(@"[TextLayout] attributeCharRange:%@", NSStringFromRange(attributeCharRange));
            
            attributeGlyphRange = [self glyphRangeForCharacterRange:attributeCharRange actualCharacterRange:NULL];
            RBSLOG(@"[TextLayout] attributeGlyphRange:%@", NSStringFromRange(attributeGlyphRange));
            
            attributeGlyphRange = NSIntersectionRange(attributeGlyphRange, lineGlyphRange);
            RBSLOG(@"[TextLayout] NSIntersectionRange:%@", NSStringFromRange(attributeGlyphRange));
            
            if( attribute != nil ) {
                //find it
                #if 0
                //when use tail font. the boundingRectForGlyphRange return incorrect value.
                CGRect boundingRect = [self boundingRectForGlyphRange:attributeGlyphRange inTextContainer:textContainer];
                #else
                CGRect boundingRect = usedRect;
                // Left border (== position) of first underlined glyph
                CGFloat firstPosition = [self locationForGlyphAtIndex: attributeGlyphRange.location].x;
                
                // Right border (== position + width) of last underlined glyph
                CGFloat lastPosition;
                
                // When link is not the last text in line, just use the location of the next glyph
                if (NSMaxRange(attributeGlyphRange) < NSMaxRange(lineGlyphRange)) {
                    lastPosition = [self locationForGlyphAtIndex: NSMaxRange(attributeGlyphRange)].x;
                }
                // Otherwise get the end of the actually used rect
                else {
                    lastPosition = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(attributeGlyphRange)-1 effectiveRange:NULL].size.width;
                }

                
                // Inset line fragment to underlined area
                boundingRect.origin.x += firstPosition;
                boundingRect.size.width = lastPosition - firstPosition;
                boundingRect.size.height = usedRect.size.height;
                
                // Offset line by container origin
                boundingRect.origin.x += origin.x;
                boundingRect.origin.y += origin.y;
                #endif
                
                RBSBorderTextStyle *borderTextStyle = attribute;
                [self drawBorder:boundingRect withFill:borderTextStyle.fillColorOnBackground byColor:borderTextStyle.color];

                RBSLOG(@"[TextLayout] attributeGlyphRange %@, boundingRect:%@", NSStringFromRange(attributeGlyphRange), NSStringFromCGRect(boundingRect));
            }
            lineGlyphRange.length = NSMaxRange(lineGlyphRange) - NSMaxRange(attributeGlyphRange);
            lineGlyphRange.location = NSMaxRange(attributeGlyphRange);
            
        }
    }];
    
    
    RBSLOG(@"[TextLayout] end Search");
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

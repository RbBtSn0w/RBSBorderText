//
//  RBSBorderTextLayoutManager.h
//  RBSBorderText
//
//  Created by Snow.y.wu on 4/25/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RBSBorderTextLayoutManager : NSLayoutManager

/**
 When you custom draw be sure, the process flow. It's from inslide to out.
 
 1. Draw background.
 2. Draw glyph ground
    1. Draw glyph underline.
    2. Draw glyph Strikethrough
 
 So first will call drawBackgroundForGlyphRange:atPoint:, then drawGlyphsForGlyphRange:atPoint:

 @param rect glyph draw in rect field
 */
- (void)drawInRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END

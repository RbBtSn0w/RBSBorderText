//
//  RBSBorderTextLabel.h
//  RBSBorderText
//
//  Created by Snow.y.wu on 4/25/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RBSBorderTextLayoutManager;

@interface RBSBorderTextLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer;

@property(nonatomic, readonly) NSTextContainer *textContainer;


/**
 This property is a convenience accessor that provides access through the text container.
 */
@property(nonatomic, readonly) RBSBorderTextLayoutManager *layoutManager;

/**
 This property is a convenience accessor that provides access through the text container.
 */
@property(nonatomic, readonly) NSTextStorage *textStorage;

@end

NS_ASSUME_NONNULL_END

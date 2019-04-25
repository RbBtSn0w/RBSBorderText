//
//  RBSBorderTextStyle.h
//  RBSBorderText
//
//  Created by Snow.y.wu on 4/25/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSAttributedStringKey const RBSBorderTextStyleAttributeName;

@interface RBSBorderTextStyle : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL fillColorOnBackground;

@end

NS_ASSUME_NONNULL_END

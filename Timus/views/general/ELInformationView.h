//
//  ELEmptyView.h
//  Timus
//
//  Created by Pedro Oliveira on 7/24/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@interface ELInformationView : UIView

@property (nonatomic, strong) NSString *informationText;

#pragma mark - Methods

- (instancetype) initWithFrame:(CGRect)frame andInformationText:(NSString*) informationText;

@end

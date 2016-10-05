//
//  ELBreakCell.h
//  Timus
//
//  Created by Emanuel Coelho on 23/01/14.
//  Copyright (c) 2014 Timus. All rights reserved.
//

#import "ELTaskCell.h"

@interface ELBreakCell : ELTaskCell

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UILabel *breakDescritpionLabel;
@property (weak, nonatomic) IBOutlet UILabel *breakTimeLabel;

@end

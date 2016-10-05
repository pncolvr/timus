//
//  ELTaskCell.h
//  Timus
//
//  Created by Emanuel Coelho on 21/04/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@interface ELTaskCell : UITableViewCell

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UILabel *tasksDescription;
@property (weak, nonatomic) IBOutlet UILabel *taskTotalWorkTimer;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBreaksLabel;

@end

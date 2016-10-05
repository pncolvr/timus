//
//  ELProjectCell.h
//  Timus
//
//  Created by Pedro Oliveira on 4/18/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@interface ELProjectCell : UITableViewCell

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UIImageView *projectImageView;
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *projectWorkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfTasksLabel;

@end

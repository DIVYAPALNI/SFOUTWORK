//
//  TextFieldCell.h
//  Ivuko
//
//  Created by Incresol on 31/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenImageOptionDelegate <NSObject>

-(void)openImageSelectOptions;


@end
@interface TextFieldCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textfieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *textfieldBG;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *camerabutton;
@property (strong, nonatomic) id<OpenImageOptionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton * addProductButton;
@property (weak, nonatomic) IBOutlet UITextField * customertTextfieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *AccName;
@property (weak, nonatomic) IBOutlet UILabel *CreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *ownedByName;
@property (weak, nonatomic) IBOutlet UIButton *displayIcon;
//new feed
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *stageLbl;
@property (weak, nonatomic) IBOutlet UILabel *probabilityLbl;
@property (weak, nonatomic) IBOutlet UILabel *closingDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UILabel *oppStatusLbl;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
//
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *stageTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *probabilityTitleLbl;

-(IBAction)openImageOptions:(id)sender;
@end

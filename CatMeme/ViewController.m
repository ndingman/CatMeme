//
//  ViewController.m
//  CatMeme
//
//  Created by NEIL DINGMAN on 2/1/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

///1   Add Imports

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

///2  Add Properties
@interface ViewController ()  {
    CGSize pageSize;
    
}

@property (nonatomic, retain) IBOutlet UITextField *myTextFieldOne;
@property (nonatomic, retain) IBOutlet UITextField *myTextFieldTwo;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *buttonPDF;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmail;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation ViewController


///3 Add argument to viewDidLoad for scroll view.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(320, 1050)];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///4  Created action method to set up pdf file and save it to NSDocumentDirectory.
- (IBAction)generatePDFButton:(id)sender {
    
    pageSize = CGSizeMake(350, 548);
    NSString *filename = @"cat.pdf";
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *pdfPathWithFileName = [documentDirectory stringByAppendingPathComponent:filename];
      NSLog(@"path:%@",[[NSBundle mainBundle]bundlePath]);
    [self generatepDF:pdfPathWithFileName];
    
    
}

///5 Create method to generate PDF and add objects to the pdf text.
-(void)generatepDF:(NSString *)filePath{
    
    /// 1 Start by initializing a creating context
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 320, 380), nil);
    /// 2 add method for various objects to call.
    [self drawBackground];
    [self drawImage];
    [self drawText];
    [self drawTextTwo];
    
    /// 3 End the creating context
    UIGraphicsEndPDFContext();
    
}

///6 Create a background method.
-(void)drawBackground{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, pageSize.width, pageSize.height);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    
}

///7 Draw text field box for top of pdf
//Update to formating the drawInRect method for iOS7.
/*http://stackoverflow.com/questions/18948180/align-text-using-drawinrectwithattributes*/
-(void)drawText{
    CGRect textRect = CGRectMake(31, 20, [[self myTextFieldOne]frame].size.width, self.myTextFieldOne.frame.size.height);
    NSString *myString = self.myTextFieldOne.text;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:20];
    UIColor *textColor = [UIColor orangeColor];
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,  NSForegroundColorAttributeName: textColor };
    
    [myString drawInRect:textRect withAttributes:attributes];
}

/// Draw text field box for bottom of pdf
-(void)drawTextTwo{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:20];
    CGRect textRect = CGRectMake(195, 320, [[self myTextFieldTwo]frame].size.width, self.myTextFieldTwo.frame.size.height);
    NSString *myString = self.myTextFieldTwo.text;
    UIColor *textColor = [UIColor orangeColor];
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,  NSForegroundColorAttributeName: textColor };
    [myString drawInRect:textRect withAttributes:attributes];
}

///8 Draw Image for pdf.
-(void)drawImage{
    
    CGRect imageRect = CGRectMake(20, 14, 282, 344);
    UIImage *image = [UIImage imageNamed:@"Cat.png"];
    [image drawInRect:imageRect];
    
}

//9  Add hides the keyboard method.
-(IBAction)textFieldShouldReturn:(UITextField *)textField {
    [_myTextFieldOne resignFirstResponder];
    [_myTextFieldTwo resignFirstResponder];}


///10  Add method for sending email.
-(IBAction)email:(id)sender{
    
    if([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate= (id)self;
        [mail setSubject:@"PDF File"];
        
        ///1 Set up the proper arguments to obtain the generated file in the previous saved file directory.
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *file = [documentsDirectory stringByAppendingPathComponent:@"cat.pdf"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        
        /// Set up argument to attach PDF to email.
        [mail addAttachmentData:data mimeType:@"application/pdf" fileName:@"cat.pdf"];
        [self presentViewController:mail animated:YES completion:^{NSLog (@"Action Completed");}];
        
    }
    else
    {
        NSLog(@"Message cannot be sent");
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissViewControllerAnimated:YES completion:^{NSLog (@"mail finished");}];
    
}

























@end

//
//  ViewController.m
//  TestApps
//
//  Created by я on 08.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "VIViewController.h"
#import "VITableDataDelegate.h"
#import "VICustomSearch.h"
#import "VIImagesLoaded.h"

@interface VIViewController ()

@end

@implementation VIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView/Field Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    VICustomSearch* searchDictionary = [[VICustomSearch alloc] init];
    VIImagesLoaded* imageURL = [[VIImagesLoaded alloc] init];
    
    @try {
        [imageURL getImageUrlFrom:[searchDictionary getJSONwithRequest:_searchField.text] andPlaceImageToUI:_itemImageView];
    }
    @catch (NSException * e) {
        NSLog(@"Image not found! Exception: %@", e);
    }
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text  isEqualToString: @"Введите описание"])
    {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text  isEqualToString: @""])
    {
        textView.text = @"Введите описание";
    }
    [textView resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)buttonSaveClick:(id)sender {
    
    VITableDataDelegate *tdd = [[VITableDataDelegate alloc] init];
    
    NSManagedObject* item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:tdd.persistentContainer.viewContext];
    
    [item setValue:_itemNameField.text forKey:@"itemName"];
    [item setValue:_itemDescriptionView.text forKey:@"itemDescription"];
    
    NSData* dataImage = [[NSData alloc] init];
    dataImage = UIImageJPEGRepresentation(_itemImageView.image, 1.0); //0.0
    
    [item setValue:dataImage forKey:@"itemImage"];

    NSError *error = nil;
    if (![tdd.persistentContainer.viewContext save:&error])
    {
        NSLog(@"%@", [error localizedDescription]);
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

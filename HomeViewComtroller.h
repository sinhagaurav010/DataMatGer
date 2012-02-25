//
//  HomeViewComtroller.h
//  DataMatrixBarCode
//
//  Created by saurav sinha on 25/02/12.
//  Copyright (c) 2012 sauravsinha007@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewComtroller : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImage *imgBarCode;
}
-(void)DecodeBarCodeWithInfo:(NSDictionary *)Info;
@end

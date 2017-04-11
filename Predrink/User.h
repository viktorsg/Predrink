//
//  User.h
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *profilePictureUri;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *favDrink;
@property (assign, nonatomic) BOOL firstLogin;
@property (assign, nonatomic) NSNumber *age;
@property (assign, nonatomic) NSNumber *joinedCount;
@property (assign, nonatomic) NSNumber *hostedCount;

@end

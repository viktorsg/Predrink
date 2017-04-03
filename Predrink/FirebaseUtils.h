//
//  FirebaseUtils.h
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FirebaseDatabase/FirebaseDatabase.h>

@interface FirebaseUtils : NSObject

+ (void)instantiateDatabse;

+ (FIRDatabaseReference *)getUsersReference;

@end

//
//  FirebaseUtils.m
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "FirebaseUtils.h"

@implementation FirebaseUtils

static FIRDatabase *database;

+ (void)instantiateDatabse {
    if(database == nil) {
        database = [FIRDatabase database];
        database.persistenceEnabled = YES;
    }
}

+ (FIRDatabaseReference *)getUsersReference {
    return [database.reference child:@"users"];
}



@end

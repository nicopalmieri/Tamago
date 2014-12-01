//
//  Pet.m
//  Tamago
//
//  Created by Nicolas on 11/24/14.
//  Copyright (c) 2014 Nicolas. All rights reserved.
//

#import "Pet.h"

@interface Pet ()

@property (nonatomic) int energy;
@property (nonatomic) int level;
@property (nonatomic) int exp;
@property (nonatomic) int exprequired;
@property (strong, nonatomic) NSDictionary *POST;
@property (strong, nonatomic) NSDictionary *GET;

@end


NSString *const MSG_LVLUP =@"Alocaverna";
NSString *const MSG_EXHAUST =@"Alobestia";
NSString *const MSG_COD_PET =@"np0114";


@implementation Pet

+ (instancetype) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^
                {
                _sharedObject = [[self alloc] init]; });
    return _sharedObject;
}

-(instancetype) initWIthNAME:(NSString *)name andType:(mascotaTypes) tipo andLevel:(int) nivel andCode: (NSString*) codigo
{
    self = [super init];
    if(self)
    {
        self.code = codigo;
        self.name = name;
        self.type = tipo;
        self.level = nivel;
        switch (tipo)
        {
            case TYPE_CIERVO:
                [self setImagen:@"ciervo_comiendo_1"];
                break;
            case TYPE_GATO:
                [self setImagen:@"gato_comiendo_1"];
                break;
            case TYPE_JIRAFA:
                [self setImagen:@"jirafa_comiendo_1"];
                break;
            case TYPE_LEON:
                [self setImagen:@"leon_comiendo_1"];
                break;
        }
    }
    return self;
}

-(void) timeToEat
{
    self.energy +=50;
    [self.delegate moreProgress:self.energy];
}

-(void) timeToExercise
{
    [self calcularExpLvl];
    if(self.energy > 0)
    {
        self.energy -= 10;
        self.exp += 15;
        NSLog(@"-10+15//%d,%d",self.energy,self.exp);
        
        if(self.exp >= self.exprequired)
        {
            self.level +=1;
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_LVLUP object:nil];
            NSLog(@"%d", self.level);
        }
        
        if(self.energy <=0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_EXHAUST object:nil];
            NSLog(@"observerSend");
        }
        [self.delegate lessProgress:self.energy];
    }
}

-(BOOL) valEjercitar
{
    return self.energy > 0;
}

-(void) calcularExpLvl
{
    self.exprequired = 100*(int)pow(self.level,2);
    NSLog(@"req: %d",self.exprequired);
}

-(void) getLvl1
{
    self.level =1;
}

-(int) showLvl
{
    return self.level;
}

-(int) showEnergy
{
    return self.energy;
}

-(int) showExp
{
    return self.exp;
}

-(NSDictionary*)fillDictionary
{
    self.POST = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSString stringWithString: MSG_COD_PET], @"code",
                [NSString stringWithString: self.name], @"name",
                [NSNumber numberWithInt:self.energy], @"energy",
                [NSNumber numberWithInt:self.level], @"level",
                [NSNumber numberWithInt:self.exp], @"experience",
                [NSNumber numberWithInt:self.type], @"pet_type",
                [NSNumber numberWithFloat:self.latitud], @"position_lat",
                [NSNumber numberWithFloat:self.longitud], @"position_lon",
                nil];
    
    return self.POST;
}

-(void)fillPet: (NSDictionary*) dictionaryGet
{
    self.name = [dictionaryGet objectForKey:@"name"];
    self.energy = ((NSNumber*)[dictionaryGet objectForKey:@"energy"]).intValue;
    self.exp = ((NSNumber*)[dictionaryGet objectForKey:@"experience"]).intValue;
    self.level = ((NSNumber*)[dictionaryGet objectForKey:@"level"]).intValue;
    self.type = ((NSNumber*)[dictionaryGet objectForKey:@"pet_type"]).intValue;
    self.latitud = ((NSNumber*)[dictionaryGet objectForKey:@"position_lat"]).floatValue;
    self.longitud = ((NSNumber*)[dictionaryGet objectForKey:@"position_lon"]).floatValue;
}

@end

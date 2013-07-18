//
//  QLKServer.m
//  QLabKit
//
//  Created by Zach Waugh on 7/9/13.
//
//  Copyright (c) 2013 Figure 53 LLC, http://figure53.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "QLKServer.h"
#import "QLKWorkspace.h"
#import "F53OSC.h"

@interface QLKServer ()

@property (strong, nonatomic) F53OSCClient *client;

@end

@implementation QLKServer

- (id)initWithHost:(NSString *)host port:(NSInteger)port
{
  self = [super init];
  if (!self) return nil;
  
  _host = host;
  _port = port;
  _workspaces = [[NSMutableArray alloc] init];
  
  _client = [[F53OSCClient alloc] init];
  _client.host = host;
  _client.port = port;
  
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - %@ - %@:%ld", [super description], self.name, self.host, self.port];
}

#pragma mark - Workspaces

- (void)refreshWorkspaces
{
  [self.client sendPacket:[F53OSCMessage messageWithAddressPattern:@"/workspaces" arguments:nil]];
}

- (void)updateWorkspaces:(NSArray *)workspaces
{
  [self removeAllWorkspaces];
  
  for (NSDictionary *dict in workspaces) {
    QLKWorkspace *workspace = [[QLKWorkspace alloc] initWithDictionary:dict server:self];
    [self addWorkspace:workspace];
  }
}

- (void)addWorkspace:(QLKWorkspace *)workspace
{
  [self.workspaces addObject:workspace];
}

- (void)removeWorkspace:(QLKWorkspace *)workspace
{
  [self.workspaces removeObject:workspace];
}

- (void)removeAllWorkspaces
{
  [self.workspaces removeAllObjects];
}

@end

//
//  WXSceneComponent.m
//  WeexDemo
//
//  Created by 齐山 on 2017/6/21.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import "WXSceneComponent.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "WXUtility.h"
#import "SSZipArchive.h"

@interface WXSceneComponent()<ARSCNViewDelegate>
@property(nonatomic, strong) ARSCNView* sceneView;
@property (nonatomic, strong) NSString *src;
@property (nonatomic, strong) NSString *file;
@property(nonatomic) NSInteger index;
@property(nonatomic) BOOL isViewDidLoad;
@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation WXSceneComponent
WX_PlUGIN_EXPORT_COMPONENT(scene,WXSceneComponent)
WX_EXPORT_METHOD(@selector(addNode:))

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        if (attributes[@"src"]) {
            _src = attributes[@"src"];
        }
        if (attributes[@"file"]) {
            _file = attributes[@"file"];
        }
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.sceneView = [[ARSCNView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.sceneView];
    self.sceneView.delegate = self;
    _sceneView.showsStatistics = YES;
    SCNScene *scene = [SCNScene new];
    _sceneView.scene = scene;
    // Run the view's session
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    configuration.worldAlignment = ARWorldAlignmentGravity;
    //    configuration.lightEstimationEnabled = YES;
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration:configuration];
//    [self addNode:@{}];
//    if(_src){
//        [self parseSrc];
//    }
    if(self.tasks){
        for (NSDictionary *option in self.tasks) {
            [self addNodeTask:option];
        }
        [self.tasks removeAllObjects];
    }
    
    self.isViewDidLoad = YES;
}



-(void)addNode:(NSDictionary *)options
{
    
    if(!self.isViewDidLoad){
        if(!_tasks){
            _tasks = [NSMutableArray new];
        }
        [_tasks addObject:options];
        return;
    }
    [self addNodeTask:options];
    
}

-(void)addNodeTask:(NSDictionary *)options
{
    SCNScene *scene = _sceneView.scene;
    
    SCNMaterial * material = [SCNMaterial new];
    material.name = [WXConvert NSString: [options objectForKey:@"name"]];
    NSDictionary *contents = [options objectForKey:@"contents"];
    NSString *type = [WXConvert NSString:[contents objectForKey:@"type"]];
    if([@"color" isEqualToString:type])
    {
        material.diffuse.contents = [WXConvert UIColor:[contents objectForKey:@"name"]];
    }
    SCNBox *box = [SCNBox boxWithWidth:[WXConvert CGFloat: [options objectForKey:@"width"]] height:[WXConvert CGFloat: [options objectForKey:@"height"]] length:[WXConvert CGFloat: [options objectForKey:@"length"]] chamferRadius:[WXConvert CGFloat: [options objectForKey:@"chamferRadius"]]];
    
    SCNNode *node = [SCNNode new];
    node.geometry = box;
    node.geometry.materials = @[material];
    NSDictionary *vector = [options objectForKey:@"vector"];
    node.position =SCNVector3Make([WXConvert CGFloat: [vector objectForKey:@"x"]] , [WXConvert CGFloat: [vector objectForKey:@"y"]], [WXConvert CGFloat: [vector objectForKey:@"z"]]);
    [scene.rootNode addChildNode:node];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
}

-(void)tapped:(UITapGestureRecognizer *)recognizer
{
    SCNView *sceneView = (SCNView *)recognizer.view ;
    CGPoint touchLocation =  [recognizer locationInView:sceneView];
    NSArray *hitResults = [sceneView hitTest:touchLocation options:nil];
    
    if(hitResults){
        
        SCNHitTestResult *res = hitResults[0];
        SCNNode *node =res.node;
        NSArray *materials= node.geometry.materials;
        for (SCNMaterial *m in materials) {
            if([m.name isEqualToString:@"Color"]){
                self.index = _index+1;
                self.index = _index%3;
                if(_index == 0){
                    m.diffuse.contents = [UIColor orangeColor];
                }
                if(_index == 1){
                    m.diffuse.contents = [UIColor greenColor];
                }
                if(_index == 2){
                    m.diffuse.contents = [UIColor blueColor];
                }
                
            }
        }
        
    }
    
}


-(void)parseSrc
{
    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL URLWithString:_src];
    [WXUtility getARImage:url completion:^(NSURL * _Nonnull url, NSError * _Nullable error) {
        if (!error && url) {
            
            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSError *zipError = nil;
            [SSZipArchive unzipFileAtPath:url.path toDestination:documentsDirectory overwrite:YES password:nil error:&zipError];
            
            if( zipError ){
                NSLog(@"[GameVC] Something went wrong while unzipping: %@", zipError.debugDescription);
            }else {
                NSLog(@"[GameVC] Archive unzipped successfully");
                [weakSelf startScene];
                // load success
                
            }
            //        NSAssert(scene, @"failed to load scene named ship.scn");
        } else {
            //there was some errors during loading
            WXLogError(@"load font failed %@",error.description);
        }
    }];
}


-(void)startScene
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =[NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],_file];
    SCNScene *scene =[SCNScene sceneWithURL:[NSURL fileURLWithPath:path] options:nil error:nil];
    NSAssert(scene, @"failed to load scene named ship.scn");
    self.sceneView.scene = scene;
}

- (UIView *)loadView
{
    if(!_sceneView){
        ARSCNView *sceneView = [[ARSCNView alloc] init];
        
        sceneView.delegate = self;
        NSString *p = [[NSBundle mainBundle]resourcePath];
        NSLog(@"%@",p);
        self.sceneView.showsStatistics = YES;
        
        _sceneView = sceneView;
    }
    return self.sceneView;
}
@end

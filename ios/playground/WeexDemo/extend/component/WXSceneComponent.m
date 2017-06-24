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
#import <WeexSDK/WXComponent+Events.h>

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
WX_EXPORT_METHOD(@selector(updateNode:))

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

-(void)updateNode:(NSDictionary *)options
{
    CGPoint touchLocation =  CGPointMake([WXConvert CGFloat: [options objectForKey:@"x"]], [WXConvert CGFloat: [options objectForKey:@"y"]]);
    NSArray *hitResults = [_sceneView hitTest:touchLocation options:nil];
    
    if(hitResults&& [hitResults count]>0){
        
        SCNHitTestResult *res = hitResults[0];
        SCNNode *node =res.node;
        NSArray *materials= node.geometry.materials;
        for (SCNMaterial *m in materials) {
            if([m.name isEqualToString:[WXConvert NSString:[options objectForKey:@"name"]]]){
                m.diffuse.contents = [WXConvert UIColor:[options objectForKey:@"color"]];
            }
        }
    }
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
    [self fireEvent:@"tap" params:@{@"touchLocation":@{@"x":@(touchLocation.x),@"y":@(touchLocation.y)}}];
    
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

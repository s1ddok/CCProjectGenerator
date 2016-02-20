import Foundation

class MainScene: CCScene {
    override init!() {
        super.init()
        
        // Background
        let sprite = CCSprite(imageNamed:"ic_launcher.png")
        sprite.position = ccp(0.5, 0.5)
        sprite.positionType = CCPositionTypeNormalized
        self.addChild(sprite)
        
        // The standard Hello World text
        let label = CCLabelTTF(string: "Hello World", fontName: "ArialMT", fontSize: 16)
        label.positionType = CCPositionTypeNormalized
        label.position = ccp(0.5, 0.25)
        self.addChild(label)
    }

}

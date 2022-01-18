import Foundation

class Weapon {
    
    var name: String
    var damage: Int
    
    static let allWeapons: [Weapon] = [Sword(), Daggers(), Bow(), Harpoon()]
    
    init(name: String, damage: Int) {
        self.name = name
        self.damage = damage
    }
    
    static func getRandomWeapon() -> Weapon {
        let randomNumber = Int.random(in: 0...allWeapons.count - 1)
        return allWeapons[randomNumber]
    }
}


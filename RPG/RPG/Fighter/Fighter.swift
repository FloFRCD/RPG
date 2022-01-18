//
//  Orc.swift
//  RPG
//
//  Created by Florian Fourcade on 17/09/2021.
//

import Foundation

class Fighter {
    
    var name: String
    var typeName: String
    var maxLife: Int
    var damage: Int
    var weapon: Weapon?
    
    var isAlive: Bool {
        life > 0
    }
    
    var life: Int {
        didSet {
            // Life points cannot drop below 0
            if life < 0 { life = 0 }
            // Life points cannot exceed Life
            if life > maxLife { life = maxLife }
        }
    }
    
    init(name: String, typeName: String, maxLife: Int, damage: Int, weapon: Weapon? = nil) {
        self.name = name
        self.typeName = typeName
        self.maxLife = maxLife
        self.damage = damage
        self.weapon = weapon
        self.life = maxLife
    }
    
    
    func attack(target: Fighter) {
        print("\(name), attaque \(target.name)")
        
        // Condition ternaire
        let weaponDamage = (weapon != nil) ? weapon!.damage : 0
        let totalDamage = damage + weaponDamage
        
        target.life = target.life - totalDamage
//        target.life -= totalDamage
        
        print("\(target.name) perd \(totalDamage)HP")
        print("\n------------------------------------------------------------------------")
    }
    
    func heal() {
        let healPoints = 250
        print("\(name) soigne \(self.name) de \(healPoints)")
        
        self.life = self.life + healPoints
        
        print("\(self.name) est soigné de \(healPoints) HP")
        print("\n------------------------------------------------------------------------")
    }
}



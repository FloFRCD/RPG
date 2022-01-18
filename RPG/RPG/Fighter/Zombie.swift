//
//  Zombie.swift
//  RPG
//
//  Created by Florian Fourcade on 29/09/2021.
//

import Foundation

class Zombie: Fighter {
    
    init() {
        super.init(name: "", typeName: "Zombie", maxLife: 3500, damage: 400)
    }
}

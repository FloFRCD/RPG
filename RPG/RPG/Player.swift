//
//  Player.swift
//  RPG
//
//  Created by Florian Fourcade on 17/09/2021.
//

import Foundation

class Player {
    var name : String
    var team: [Fighter] = []
    
    init(name: String, team: [Fighter]) {
        self.name = name
        self.team = team
    }
    

static func getFighter(for player: Player) -> Fighter {
    var livingFighters: [Fighter] {
        player.team.filter { (fighter) -> Bool in
            fighter.isAlive
        }
    }
    
    print("\nSélectionne un personnage :")
    for (index, fighter) in livingFighters.enumerated() {
        print("\(index + 1) \(fighter.name) le \(fighter.typeName). Il lui reste \(fighter.life)HP et inflige \(fighter.damage) dégats")
    }
    
    var fighter: Fighter!
    var selectedChoice = readLine()!
    
    var aliveFighterSelected = false
    while aliveFighterSelected == false {
        if let choice = Int(selectedChoice),
           choice >= 1 && choice <= livingFighters.count {
            fighter = livingFighters[choice - 1]
            aliveFighterSelected = true
        } else {
            print("Tape un chiffre entre 1 et \(livingFighters.count)")
            selectedChoice = readLine()!
        }
    }
    
    return fighter
}
static func showStatistics() {
    var players: [Player] = []
    let firstTeam = players[0].team
    let secondTeam = players[1].team
    
    let firstTeamIsDead = firstTeam[0].life <= 0 && firstTeam[1].life <= 0 && firstTeam[2].life <= 0
    let secondTeamIsDead = secondTeam[0].life <= 0 && secondTeam[1].life <= 0 && secondTeam[2].life <= 0
    
    
    if firstTeamIsDead == true {
        print("Felicitation \(players[1].name) vous avez gagné la partie !!")
    }
    if secondTeamIsDead == true {
        print("Felicitation \(players[0].name) vous avez gagné la partie !!")
    }
    print("Partie terminée en \(round) rounds\n")
    
    for player in players {
        print("Equipe de \(player.name):")
        for (index, fighter) in player.team.enumerated() {
            print("\(index + 1). \(fighter.name) le \(fighter.typeName) a \(fighter.life)HP.")
        }
        print("\n")
    }
}
}

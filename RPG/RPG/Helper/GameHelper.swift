//
//  GameHelper.swift
//  RPG COPIE
//
//  Created by Florian Fourcade on 30/11/2021.
//

import Foundation

class GameHelper {
    
    static func initFakePlayers() -> [Player] {
        var players: [Player] = []
        
        for i in 1...2 {
            let playerName = "Player\(i)"
            
            var team: [Fighter] = []
            
            for i in 1...3 {
                let orc = Orc()
                orc.name = "Orc\(i)"
                orc.life = 2
                team.append(orc)
            }
            
            let player = Player(name: playerName, team: team)
            players.append(player)
        }
        
        return players
    }
}

//
//  Game.swift
//  RPG
//
//  Created by Florian Fourcade on 29/09/2021.
//


import Foundation

class Game {
    private var allFighters: [Fighter] = [Orc(), Cyclope(), Loup(), Zombie(), Chevalier(), Aigle()]
    private var players: [Player] = []
    private var round: Int = 1
    
    func start() {
        // Pour éviter de réinitialiser à chaque fois les players, j'utilise un GameHelper 
        // self.players = GameHelper.initFakePlayers()
        initPlayers()
        play()
        Player.showStatistics()
    }
    
    private func initPlayers() {
        print("Bienvenue dans Bad Game, le jeu pas mal")
        print("Bad Game est un jeu joueur contre joueur (PvP), le premier a detuire l'equipe d'en face gagne la partie. Avant de vous battre, vous devrait composer une equipe de trois combattants et les nommer")
        
        for fighter in allFighters {
            print ("\(fighter.name) Il a \(fighter.life)pdv et inflige \(fighter.damage) dégats de base")
        }
        
        print("\nContenu des coffres :")
        for (index, weapon) in Weapon.allWeapons.enumerated() {
            print("\(index + 1) \(weapon.name) : Augmente les dommages du combattant de \(weapon.damage)")
        }
        
        for i in 1...2  {
            print("\nBonjour joueur \(i), veuillez choisir votre nom :")
            var playerName = readLine()!
            
            var nameIsAlreadyUsed = true
            
            while nameIsAlreadyUsed {
                let nameIsValidate = validate(playerName: playerName, withPlayers: players)
                
                var message = "Nom pas disponnible, veuillez en choisir un autre:"
                if playerName.isEmpty {
                    message = "Nom vide, veuillez entrer le nom d'un personnage:"
                }
                
                if nameIsValidate && !playerName.isEmpty {
                    nameIsAlreadyUsed = false
                } else {
                    print(message)
                    playerName = readLine()!
                }
            }
            
            var team: [Fighter] = []
            
            for i in 1...3 {
                print("Veuillez choisir votre personnage n°\(i)")
                
                let allFighters = [Orc(), Cyclope(), Loup(), Zombie(), Chevalier(), Aigle()]
                for (index, fighter) in allFighters.enumerated() {
                    print("\(index + 1). \(fighter.typeName)")
                }
                
                var fighterChoice = readLine()!
                var selectedFighter: Fighter!
                
                var fighterIsNotSelected = true
                while fighterIsNotSelected {
                    if let choice = Int(fighterChoice),
                       (choice >= 1) && (choice <= allFighters.count) {
                        selectedFighter = allFighters[choice - 1]
                        fighterIsNotSelected = false
                    } else {
                        print("Veuillez choisir votre personnage n°\(i) - Entre 1 et \(allFighters.count) !")
                        for (index, fighter) in allFighters.enumerated() {
                            print("\(index + 1). \(fighter.typeName)")
                        }
                        
                        fighterChoice = readLine()!
                    }
                }
                
                // Vérification du nom du fighter
                print("Veuillez choisir un nom pour votre \(selectedFighter.typeName) :")
                var fighterName = readLine()!
                var fighterNameIsAlreadyUsed = true
                
                while fighterNameIsAlreadyUsed {
                    let fighterNameIsValidated = validate(fighterName: fighterName, withFighters: team)
                    if fighterNameIsValidated {
                        fighterNameIsAlreadyUsed = false
                    } else {
                        print("Nom pas disponnible, veuillez en choisir un autre:")
                        fighterName = readLine()!
                    }
                }
                
                selectedFighter.name = fighterName
                team.append(selectedFighter)
            }
            
            let player = Player(name: playerName, team: team)
            players.append(player)
        }
    }
    
    private func play() {
        var attacker = players[0]
        var target = players[1]
        
        while thereIsNoWinner() {
            print("Tour de personnage n°\(round)\n")
            
            // TODO: Demander si le joueur souhaite attaquer ou soigner son personnage (
            var actionChoiceIsNotDone = true
            while actionChoiceIsNotDone {
                print("\(attacker.name), veux-tu attaquer un personnage ennemi ou soigner un de tes personnages ?\n1. Soigner \n2. Attaquer")
                
                // number typed by player
                guard let actionChoice = getUserChoice(between: 1, and: 2) else {
                    print("Tu as fait une erreur, il n'y a pourtant que 2 choix :/ \n")
                    continue
                }
                actionChoiceIsNotDone = false
                // TODO: Vérifier les entrées du clavier "toto" - 68
                let selectedFighter = Player.getFighter(for: attacker)
                setWeaponIfNeeded(for: selectedFighter)
                
                let userHasChoosenToHeal = actionChoice == 1
                if userHasChoosenToHeal {
                    print("\(attacker.name) choisi de soigner son personnage")
                    selectedFighter.heal()
                } else {
                    print("\(attacker.name), choisi la cible que tu veux attaquer \n")
                    print("------------------------------------------------------------------------")
                    // TODO: Vérifier les entrées du clavier "toto" - 68
                    let targetFighter = Player.getFighter(for: target)
                    selectedFighter.attack(target: targetFighter)
                }
            }
            
            swap(&attacker, &target)
            round += 1
        }
    }
        // STATS

}

extension Game {
    func validate(playerName: String, withPlayers players: [Player]) -> Bool {
        for player in players {
            if player.name == playerName {
                return false
            }
        }
        return true
    }
    
    func validate(fighterName: String, withFighters fighters: [Fighter]) -> Bool {
        for fighter in fighters {
            if fighter.name == fighterName {
                return false
            }
        }
        return true
    }
    
    private func getUserChoice(between minChoice: Int, and maxChoice: Int) -> Int? {
        guard let typed = readLine(),
              let choice = Int(typed),
              choice >= minChoice && choice <= maxChoice else {
                  return nil
              }
        
        return choice
    }
    

    
    // MARK: - CHEST + GETFIGHTER
    func setWeaponIfNeeded(for fighter: Fighter) {
        let randomAppear = Int.random(in: 1...8)
        if randomAppear == 1 || randomAppear == 3 || randomAppear == 7 {
            let weapon = Weapon.getRandomWeapon()
            print("Tu as de la chance ! Un coffre apparait devant toi")
            print("Il contient \(weapon.name), qui inflige \(weapon.damage) cet objet remplace celui que tu possedais")
            fighter.weapon = weapon
        }
    }
    
    func thereIsNoWinner() -> Bool {
        let firstTeam = players[0].team
        let secondTeam = players[1].team
        
        let firstTeamIsDead = firstTeam[0].life <= 0 && firstTeam[1].life <= 0 && firstTeam[2].life <= 0
        let secondTeamIsDead = secondTeam[0].life <= 0 && secondTeam[1].life <= 0 && secondTeam[2].life <= 0
        
        return !firstTeamIsDead && !secondTeamIsDead
    }
}

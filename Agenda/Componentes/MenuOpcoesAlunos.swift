//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 15/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

enum MenuActionSheetAluno {
    case sms
    case ligacao
    case waze
    case mapa
}

class MenuOpcoesAlunos: NSObject {
    
    func configuraMenuOpcoesDoAluno(completion:@escaping(_ opcao: MenuActionSheetAluno) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção", message: "escolha uma das opcões", preferredStyle: .actionSheet)        
        let sms = UIAlertAction(title: "enviar SMS", style: .default) { (acao) in
            completion(.sms)
        }
        menu.addAction(sms)
        
        let ligacao = UIAlertAction(title: "ligar", style: .default) { (acao) in
            completion(.ligacao)
        }
        menu.addAction(ligacao)
        
        let waze = UIAlertAction(title: "localizar no waze", style: .default) { (acao) in
            completion(.waze)
        }
        menu.addAction(waze)
        
        let mapa = UIAlertAction(title: "localizar no mapa", style: .default) { (acao) in
            completion(.mapa)
        }
        menu.addAction(mapa)
        
        let cancelar = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        return menu
        
    }
}

//
//  Notificacao.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 17/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Notificacao: NSObject {
    func exibeNotificacaoDeMediasDosAlunos(dicionarioDeMedia: Dictionary<String, Any>) -> UIAlertController? {
        
        if let media = dicionarioDeMedia["media"] as? String {
            let alerta = UIAlertController(title: "Atenção", message: "A media geral dos alunos é: \(media)", preferredStyle: .alert)
            let botao = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(botao)
            
            return alerta
        }
        
        return nil
    }
}

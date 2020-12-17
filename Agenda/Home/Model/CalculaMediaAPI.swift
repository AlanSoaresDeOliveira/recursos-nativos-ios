//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 17/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {

    func calculaMediaGeralDeAlunos(alunos:Array<Aluno>, sucesso:@escaping(_ dicionarioDeMedias: Dictionary<String, Any>) -> Void, falha:@escaping(_ error: Error) -> Void) {
        
        guard let url = URL(string: "https://www.caelum.com.br/mobile") else { return }
        var listaDeAlunos: Array<Dictionary<String, Any>> = []
        var json: Dictionary<String, Any> = [:]
        
        for aluno in alunos {
            
            guard let nome = aluno.nome else { break }
            guard let endereco = aluno.endereco else { break }
            guard let telefone = aluno.telefone else { break }
            guard let site = aluno.site else { break }
            
            let dicionarioDeAluno = [
                "id": "\(aluno.objectID)",
                "nome": nome,
                "endereco": endereco,
                "telefone": telefone,
                "site": site,
                "nota": String(aluno.nota)
            ]
            listaDeAlunos.append(dicionarioDeAluno as [String: Any])
        }
        
        
        
        json = [
            "list": [
                ["aluno": listaDeAlunos]
            ]
        ]
        
        print(json)
        
        do {
            var requisicao = URLRequest(url: url)
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            requisicao.httpBody = data
            requisicao.httpMethod = "POST"
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: requisicao, completionHandler: { (data, response, error) in
                if error == nil {
                    do {
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                        sucesso(dicionario)
                    } catch {
                        falha(error)
                    }
                }
            })
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
}

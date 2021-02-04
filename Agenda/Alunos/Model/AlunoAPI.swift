//
//  AlunoAPI.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 04/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import Alamofire

class AlunoAPI: NSObject {
    
    // MARK: - GET
    
    func recuperaAlunos() {
        let respose = AF.request("http://localhost:3333/alunos")
        respose.responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                guard let listaAlunos = data as? Array<Dictionary<String, String>> else { return  }
                for dicionarioDeAluno in listaAlunos {
                    AlunoDAO().salvaAluno(dicionarioAluno: dicionarioDeAluno)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
    
    // MARK: - POST
    
    func salvaAlunosNoServidor(parametros: [String: String]) {
//        guard let url = URL(string: "http://localhost:3333/alunos") else { return }
//        var requisicao = URLRequest(url: url)
//        requisicao.httpMethod = "POST"
//        let json = try! JSONSerialization.data(withJSONObject: parametros, options: [])
//        requisicao.httpBody = json
//        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request("http://localhost:3333/alunos", method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseJSON { respnse in
            debugPrint(respnse)
        }
    }
}

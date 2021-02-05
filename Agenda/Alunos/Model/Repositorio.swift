//
//  Repositorio.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 04/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {

    func recuperaAlunos(completion: @escaping(_ listaDeAlunos: Array<Aluno>) -> Void) {           
        
        var alunos = AlunoDAO().recuperarAlunos()
        if alunos.count == 0 {
            AlunoAPI().recuperaAlunos {
                alunos = AlunoDAO().recuperarAlunos()
                completion(alunos)
            }
        } else {
            completion(alunos)
        }
        
        
    }
    
    func salvaAluno(aluno: [String: String]) {
        AlunoAPI().salvaAlunosNoServidor(parametros: aluno)
        AlunoDAO().salvaAluno(dicionarioAluno: aluno)
    }
    
    func deletaAluno(aluno: Aluno) {
        guard let id = aluno.id else { return }
        AlunoAPI().deletaAluno(id: String(describing: id))
        AlunoDAO().deletaAluno(aluno: aluno)
    }
    
    func sincronizaAlunos() {
        let alunos = AlunoDAO().recuperarAlunos()
        
        for  aluno in alunos {
            
            guard let alunoid = aluno.id else { return }
            let id = String(describing: alunoid)
            
            let parametros: Dictionary<String, String> = [
                "id": id,
                "nome": aluno.nome ?? "",
                "endereco": aluno.endereco ?? "",
                "telefone": aluno.telefone ?? "",
                "site": aluno.site ?? "",
                "nota": "\(aluno.nota)",
            ]
            AlunoAPI().salvaAlunosNoServidor(parametros: parametros)
        }
        
        
    }
}

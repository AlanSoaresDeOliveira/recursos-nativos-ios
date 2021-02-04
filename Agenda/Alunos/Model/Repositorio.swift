//
//  Repositorio.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 04/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {

    func salvaAluno(aluno: [String: String]) {
        AlunoAPI().salvaAlunosNoServidor(parametros: aluno)
        AlunoDAO().salvaAluno(dicionarioAluno: aluno)
    }
}

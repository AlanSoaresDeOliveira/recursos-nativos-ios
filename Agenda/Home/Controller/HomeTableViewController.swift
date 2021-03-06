//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class HomeTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)    
    var alunoViewController: AlunoViewController?
    let mensagem = Mensagem()
    var alunos: Array<Aluno> = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recuperaAlunos()
    }
    
    // MARK: - Métodos
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAlunos() {
        Repositorio().recuperaAlunos { (listadeAlunos) in
            self.alunos = listadeAlunos
            self.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alunoSelecionado = alunos[indexPath.row]
        alunoViewController?.aluno = alunoSelecionado
    }
    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            let alunoSelecionado = alunos[(longPress.view?.tag)!]
            let menu = MenuOpcoesAlunos().configuraMenuOpcoesDoAluno { (opcao) in
                switch opcao {
                case    .sms:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado) {
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                case   .ligacao:
                    guard let numeroDoAluno = alunoSelecionado.telefone else { return }
                                        
                    if let url = URL(string: "tel://\(numeroDoAluno)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break
                case    .waze:
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return }
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoDoAluno, local: { (localizacaoEncontrada) in
                            let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                            let url:String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        })
                    }
                    break
                case    .mapa:
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                    break
                    
                case .abrirPaginaWeb:
                    
                    if let urlDoAluno = alunoSelecionado.site {
                        var urlFormatada = urlDoAluno
                        
                        if !urlFormatada.hasPrefix("https://") {
                            urlFormatada = String(format: "https://%@", urlFormatada)
                        }
                        
                        guard let url = URL(string: urlFormatada) else { return }
                        let safiraViewController = SFSafariViewController(url: url)
                        self.present(safiraViewController, animated: true, completion: nil)
                    }
                    
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        CalculaMediaAPI().calculaMediaGeralDeAlunos(alunos: alunos) { (diconario) in
            if let alerta = Notificacao().exibeNotificacaoDeMediasDosAlunos(dicionarioDeMedia: diconario) {
                self.present(alerta, animated: true, completion: nil)
            }            
        } falha: { (error) in
            print(error.localizedDescription)
        }

    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        cell.tag = indexPath.row
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        let aluno = alunos[indexPath.row]
        cell.configuraCelula(aluno)
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            AutenticacaoLocal().autorizaUsuario { (autenticacao) in
                if autenticacao {
                    DispatchQueue.main.sync {
                        let alunoSelecionado = self.alunos[indexPath.row]
                        Repositorio().deletaAluno(aluno: alunoSelecionado)
                        self.alunos.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
        default:
            tableView.reloadData()
        }
    }
    
    
    // MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    @IBAction func buttonLocalizacaoGeral(_ sender: UIBarButtonItem) {
        let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mapa")
        navigationController?.pushViewController(mapa, animated: true)
        
    }
    
}

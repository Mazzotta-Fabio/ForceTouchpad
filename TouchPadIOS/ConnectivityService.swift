//
//  ConnectivityService.swift
//  TirocinioTouchPad
//
//  Created by Fabio Mazzotta on 09/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Mostra {
    func showConnessi(nomi: [String])
}

class ConnectivityService: NSObject {
    //costante che viene utilizzata per identificare univocamente il servizio
    private let uniquelyService="touchPadServ"
    //definiamo un mcPeer per conoscere i dispositivi con cui stiamo comunicando
    private let myPeerId=MCPeerID(displayName: UIDevice.current.name)
    //definiamo una variabile che viene utilizzata per annunciare il servizio di connessione
    private let serviceAdvertiser:MCNearbyServiceAdvertiser
     //con il delegato gestiamo tutti gli eventi relativi all'instaurazione del servizio
    private var serviceDelegate:MCNearbyServiceAdvertiserDelegate?
    //utilizzato per ricercare altri dispositivi per poter comunicare
    let serviceBrowser:MCNearbyServiceBrowser
    //con il delegato gestiamo tutti gli eventi relativi alla ricerca degli altri utenti
    private var serviceDelegateBroswer:MCNearbyServiceBrowserDelegate?
    var prot: Mostra?
    /*
       definiamo un mcSession lazy per poter iniziare a comunicare con i nostri dispositivi
          lazy per poter fare in modo di creare la sessione solo quando ci serve
    */
    
    private var serviceDelegateSession:MCSessionDelegate?
    lazy var sessionMC:MCSession = {
        let session=MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        self.serviceDelegateSession=session.delegate
        return session
    }()
    
    override init() {
        self.serviceAdvertiser=MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: uniquelyService)
        self.serviceBrowser=MCNearbyServiceBrowser(peer: myPeerId, serviceType: uniquelyService)
        self.serviceDelegate=serviceAdvertiser.delegate
        self.serviceDelegateBroswer=serviceBrowser.delegate
        super.init()
        //con questo diamo inizio alla comunicazione
        self.serviceAdvertiser.startAdvertisingPeer()
        //con questo diamo l'inizio alla ricerca dei dispositivi
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    //quando la classe viene deallocata chiamiamo deinit per stoppare la connesione e la ricerca degli utenti
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    //metodo che utilizziamo per spedire:
    func sendMotion(moviment: Double,direction:String){
        if(self.sessionMC.connectedPeers.count>0){
            do{
                var dataMoviment:String
                dataMoviment=String(moviment)
                dataMoviment=dataMoviment + " " + direction
                try self.sessionMC.send(dataMoviment.data(using: .utf8)!, toPeers: self.sessionMC.connectedPeers, with: .reliable)
            }
            catch let error{
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
     //restituisce i nomi dei peer connessi
    func showPeer()->[String]{
        return self.sessionMC.connectedPeers.map{$0.displayName}
    }
}

/*
 utilizziamo le estensioni potenziamo la classe con ulteriori servizi aggiuntivi
    inoltre possiamo potenziare i metodi già presenti senza dover modificare la classe ogni volta
 */

extension ConnectivityService: MCNearbyServiceAdvertiserDelegate{
    //metodi del delegato per gestire le operazioni di installazione della connessione offerti da MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        //accettiamo gli inviti ricevuti per unirci ad una connessione
        invitationHandler(true, self.sessionMC)
    }
}

extension ConnectivityService:MCNearbyServiceBrowserDelegate{
    
    //metodi del delegato per gestire le operazioni di installazione della connessione offerti da MCNearbyServiceBroswerDelegate
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        //invitiamo i peer connessi ad unirsi alla nostra connessione
        NSLog("%@", "invitePeer: \(peerID)")
        self.serviceBrowser.invitePeer(peerID, to: self.sessionMC, withContext: nil, timeout: 3600)
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

extension ConnectivityService : MCSessionDelegate{
    //metodi utilizzati dal delegato mcSession per poter gestire gli eventi sulla comunicazione
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.prot?.showConnessi(nomi: self.showPeer())
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}

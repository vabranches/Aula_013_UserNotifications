
import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var meuDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Autorizacao para utilizar notificacoes
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (aceito, erro) in
            if !aceito {
                print("Acesso a notificações negado pelo usuário")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        


    }

    //MARK: Actions
    @IBAction func mudarData(_ sender: UIDatePicker) {
        let dataSelecionada = sender.date
        dispararNotificacao(na: dataSelecionada)
    }

    //MARK: Metodos Personalizados
    func dispararNotificacao(na data : Date) {
        
        //Gatinho de escolha da data
        //let gatilho = UNTimeIntervalNotificationTrigger //Por tempo
        let gatilho = UNCalendarNotificationTrigger(dateMatching: data.paraDateComponents, repeats: false) //Por data
        
        //Conteudo da notificacao
        let conteudo = UNMutableNotificationContent()
        conteudo.title = "Notificação do Calendário"
        conteudo.body = "Notificação local agendada."
        conteudo.sound = UNNotificationSound.default()
        conteudo.categoryIdentifier = "minhaCategoria"
        
        //Botão da notificação
        let acaoRelembrar = UNNotificationAction(identifier: "relembrar", title: "Me lembre mais tarde", options: [])
        let categoria = UNNotificationCategory(identifier: "minhaCategoria", actions: [acaoRelembrar], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([categoria])
        
        //Requisiçao de apresentacao da notificacao
        let requisicao = UNNotificationRequest(identifier: "textoNotificacao", content: conteudo, trigger: gatilho)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //Remove as notificacoes anteriores
        
        UNUserNotificationCenter.current().add(requisicao, withCompletionHandler: nil)
        
    }
    
    //MARK: Metodos de UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "relembrar" {
            let novaData = Date(timeInterval: 61.0, since: Date())
            dispararNotificacao(na: novaData)
        }
    }

}


//MARK: Extensao da classe Date para converter em DateComponents

extension Date{
    var paraDateComponents : DateComponents {
        let calendario = Calendar(identifier: .gregorian)
        let componentes = calendario.dateComponents(in: .current, from: self)
        let novosComponentes = DateComponents(calendar: calendario, timeZone: .current, month: componentes.month, day: componentes.day, hour: componentes.hour, minute: componentes.minute)
        return novosComponentes
    }
}

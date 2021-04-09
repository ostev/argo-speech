//
//  Command.swift
//  DashTen
//
//  Created by Oscar Stevens on 18/12/20.
//

import Foundation

enum Angle: Int {
    case minusNinety = -90,
         minusEightyFive = -85,
         minusEighty = -80,
         minusSeventyFive = -75,
         minusSeventy = -70,
         minusSixtyFive = -65,
         minusSixty = -60,
         minusFiftyFive = -55,
         minusFifty = -50,
         minusFortyFive = -45,
         minusForty = -40,
         minusThirtyFive = -35,
         minusThirty = -30,
         minusTwentyFive = -25,
         minusTwenty = -20,
         minusFifteen = -15,
         minusTen = -10,
         minusFive = -5,
         zero = 0,
         five = 5,
         ten = 10,
         fifteen = 15,
         twenty = 20,
         twentyFive = 25,
         thirty = 30,
         thirtyFive = 35,
         forty = 40,
         fortyFive = 45,
         fifty = 50,
         fiftyFive = 55,
         sixty = 60,
         sixtyFive = 65,
         seventy = 70,
         seventyFive = 75,
         eighty = 80,
         eightyFive = 85,
         ninety = 90
}

enum Speed: Int {
    case minusOneHundred = -100,
         minusNinetyFive = -95,
         minusNinety = -90,
         minusEightyFive = -85,
         minusEighty = -80,
         minusSeventyFive = -75,
         minusSeventy = -70,
         minusSixtyFive = -65,
         minusSixty = -60,
         minusFiftyFive = -55,
         minusFifty = -50,
         minusFortyFive = -45,
         minusForty = -40,
         minusThirtyFive = -35,
         minusThirty = -30,
         minusTwentyFive = -25,
         minusTwenty = -20,
         minusFifteen = -15,
         minusTen = -10,
         minusFive = -5,
         zero = 0,
         five = 5,
         ten = 10,
         fifteen = 15,
         twenty = 20,
         twentyFive = 25,
         thirty = 30,
         thirtyFive = 35,
         forty = 40,
         fortyFive = 45,
         fifty = 50,
         fiftyFive = 55,
         sixty = 60,
         sixtyFive = 65,
         seventy = 70,
         seventyFive = 75,
         eighty = 80,
         eightyFive = 85,
         ninety = 90,
         ninetyFive = 95,
         oneHundred = 100
}

extension Speed: CustomStringConvertible {
    var description: String {
        "Speed(\(String(rawValue))"
    }
    
    
}

/// Represents a command to be sent to the vehicle
enum Command: Equatable {
    /// A command to set the target angle of the vehicle.
    case setAngle(Angle)
    /// A command to set the target speed of the vehicle
    case setSpeed(Speed)
}

struct CommandWithInvocation: Equatable {
    let command: Command
    let invocation: String
}

enum Result<T, E> {
    case ok(_ value: T)
    case error(_ error: E)
}

typealias HTTPResult = Result<Result<(URLResponse, Data), URLResponse>, Error>

func sendRequest(toUrl url: URL, method: String, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: callback)
    
    task.resume()
}

func fetchData(atUrl url: URL, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
    sendRequest(toUrl: url, method: "GET", callback: callback)
}

let startUrl = "http://192.168.1.114/set"

func handler(data: Data?, response: URLResponse?, error: Error?) {

    if let error = error {
        print("HTTP error: \(error)")
        return
    }
    
    if let response = response as? HTTPURLResponse {
//        print("HTTP request status code: \(response)")
    }
    
    if let data = data, let dataString = String(data: data, encoding: .utf8) {
//        print("HTTP request response: \(dataString)")
    }
}

struct Model {
    var isRecording = false
    private var internalTranscript = ""

    let onRecognised: (Model) -> Void

    init(onRecognised: @escaping (Model) -> Void) {
        self.onRecognised = onRecognised
    }

    var transcript: String {
        get {
            return internalTranscript
        }
        set(newValue) {

            internalTranscript = newValue.lowercased().replacingOccurrences(of: "zero", with: "0").lowercased().replacingOccurrences(of: " ", with: "")
            print(internalTranscript)

            let range = NSRange(location: 0, length: internalTranscript.utf16.count)

            let regex = try! NSRegularExpression(pattern: #"(?<oneWord>stop|straight|slow|moderate|fast|reverse|left|right|moon|star)|((?<command>speed|angle)(?<dash>\p{Pd}?)(?<number>\d\d?\d?))"#, options: [])
//            let results = regex.matches(in: internalTranscript, range: range)

            var commands: [CommandWithInvocation] = []
            regex.enumerateMatches(in: internalTranscript, options: [], range: range) {
                (result, _, stop) in
                guard let result = result else { return }

                if let oneWordRange = Range(result.range(withName: "oneWord"), in: internalTranscript) {

                    let oneWord = internalTranscript[oneWordRange]
                    print(oneWord)
                    
                    switch oneWord {
                    case "stop":
                        let url = URL(string: startUrl + "/speed/0")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "slow":
                        let url = URL(string: startUrl + "/speed/20")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "moderate":
                        let url = URL(string: startUrl + "/speed/50")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "fast":
                        let url = URL(string: startUrl + "/speed/80")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "reverse":
                        let url = URL(string: startUrl + "/speed/-30")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "left":
                        let url = URL(string: startUrl + "/angle/-45")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "right":
                        let url = URL(string: startUrl + "/angle/45")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "moon":
                        let url = URL(string: startUrl + "/angle/-90")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "star":
                        let url = URL(string: startUrl + "/angle/90")!
                        
                        fetchData(atUrl: url, callback: handler)
                    case "straight":
                        let url = URL(string: startUrl + "/angle/0")!
                        
                        fetchData(atUrl: url, callback: handler)
                    default:
                        print("This should never happen.")
                    }

                    } else if let numberRange = Range(result.range(withName: "number"), in: internalTranscript),
                              let commandRange = Range(result.range(withName: "command"), in: internalTranscript), let dashRange = Range(result.range(withName: "dash"), in: internalTranscript) {
                        let startNumber = Int(internalTranscript[numberRange])
                        let commandType = internalTranscript[commandRange]
                        let dash = internalTranscript[dashRange]
                        
                        var number = startNumber ?? 0
                        
                        if dash.count != 0 {
                            number *= -1
                        }
                    
                        let command: Command = commandType == "speed" ? .setSpeed( Speed(rawValue: number) ?? .zero) : .setAngle( Angle(rawValue: number) ?? .zero)

                        
                        if command == self.command?.command {
                            print("")
                        
                        }
                    
                    let invocation = internalTranscript[Range(result.range, in: internalTranscript)!]
                    
                    let commandWithInvocation = CommandWithInvocation(command: command, invocation: String(invocation))
                    
                    commands.append(commandWithInvocation)
                    
                    switch command {
                    case .setSpeed(let speed):
                        let url = URL(string: startUrl + "/speed/\(speed.rawValue)")!

                        fetchData(atUrl: url, callback: handler)
                    case .setAngle(let angle):
                        let url = URL(string: startUrl + "/angle/\(angle.rawValue)")!

                        fetchData(atUrl: url, callback: handler)
                    }
                    onRecognised(self)
                }
            }
//            print(commands)
            command = commands.last
            print(command ?? "No command recognised.")
        }
    }
    var command: CommandWithInvocation? = nil
}

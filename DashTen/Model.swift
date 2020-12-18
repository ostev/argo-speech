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
         oneHundred
}

/// Represents a command to be sent to the vehicle
enum Command {
    /// A command to set the target angle of the vehicle.
    case setAngle(_: Angle)
    /// A command to set the target speed of the vehicle
    case setSpeed(_: Speed)
}

//
//  Constants.swift
//  Salon
//
//  Created by Rahul Tiwari on 4/2/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import Foundation
import UIKit
class Services: NSObject {
   static let Shared = Services()
     let HairArray = [
        "HAIR",
        "BLOW DRY",
        "UP DO",
        "BRAIDS",
        "WOMEN HAIRCUT",
        "MEN HAIRCUT",
        "CHILDREN HAIRCUT",
        "BANG CUT",
        "SINGLE PROCESS",
        "DOUBLE PROCESS",
        "FULL HIGHLIGHT",
        "PARTIAL HIGHLIGHT",
        "BALLAYAGE",
        "DEEP CONDITIONGING",
        "KERATIN TREATMENT",
        "GLOSS"]
    let NailsArray = [
        "NAILS",
        "MANICURE",
        "PEDICURE",
        "GEL MANICURE",
        "ACRYKIC NAILS"]
    let EyeBrowsArray = [
        "EYEBROWS",
        "BROW TWEEZE",
        "BROW WAX",
        "BROW TINT ",
        "BROW THREADING",
        "BROW TATOOING",
        "BROW SHAPING"]
    let EyelashArray = [
        "EYELASH",
        "EYELASH EXTENTI..",
        "EYELASH TINT",
        "EYELASH CURL"]
    let MakeUpArray = [
        "MAKE UP",
        "MAKE UP APP..FU..",
        "EYLASH TINT",
        "MAKE UP APP..EY..."]
    let MassageSpaArray = [
        "MASSAGESPA",
        "SPORT MASSAGE",
        "SWEDISH MASSAGE",
        "HOT STONE MASSAGE ",
        "DEEP TISSUE MASSAGE",
        "BODY SCRUB"]
    let TanningArray = [
        "TANNING",
        "AIRBRUSH TANNING",
        "SPRAY TAN"]
    let WAXArray = [
        "Wax",
        "BRAZILLIAN WAX",
        "BIKINI WAX",
        "CHIN WAX",
        "UNDERARM WAX",
        "BACK WAX"]
    let DogArray = [
        "DOG CARE",
        "WASH AND DRY",
        "TRIM",
        "NAILS",
        "TEETH CLEANING"]
    
    let SkinArray = [
        "SKIN CARE",
        "FACIAL",
        "DERMAL FILLER",
        "BOTOX",
        "PHOTO FACIAL",
        "FACIAL HAIR REMOVAL"]
    
    func Hair(Index:Int) -> String {
        return HairArray[Index]
    }
    func Nail(Index:Int) -> String {
        return NailsArray[Index]
    }
    func EyeBrow(Index:Int) -> String {
        return EyeBrowsArray[Index]
    }
    func EyeLash(Index:Int) -> String {
        return EyelashArray[Index]
    }
    func MakeUp(Index:Int) -> String {
        return MakeUpArray[Index]
    }
    func MassageSpa(Index:Int) -> String {
        return MassageSpaArray[Index]
    }
    func Tanning(Index:Int) -> String {
        return TanningArray[Index]
    }
    func Wax(Index:Int) -> String {
        return WAXArray[Index]
    }
    func Dog(Index:Int) -> String {
        return DogArray[Index]
    }
    func Skin(Index:Int) -> String {
        return SkinArray[Index]
    }
}

//
//  Constants.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/16/22.
//

import Foundation

let AccessKey = "MObmlTg9GOfZiWgpArGKH788dQ3e221cI-0pYF1BEFc"
let SecretKey = "yItIR_JNM7SbG7tSmuMXIzW98ivnBIacUbO3hlX8u4Q"

let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
//White-listed addresses to redirect to after authentication success OR failure (e.g. https://mysite.com/callback)
//Use one line per URI
//Use urn:ietf:wg:oauth:2.0:oob for local tests
//urn:ietf:wg:oauth:2.0:oob (Authorize)

let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!









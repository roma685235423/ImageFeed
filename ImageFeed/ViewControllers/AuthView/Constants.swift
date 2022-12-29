//
//  Constants.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/16/22.
//

import Foundation

let AccessKey = "lHCFEGnBP871ogZAWrA69LFt22cYqyPvWoJxF6s9FjQ"
let SecretKey = "UZKBl9pKXc8rTM8Qmk32rNaozH6XJeifpn3M8huP4es"

let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
//White-listed addresses to redirect to after authentication success OR failure (e.g. https://mysite.com/callback)
//Use one line per URI
//Use urn:ietf:wg:oauth:2.0:oob for local tests
//urn:ietf:wg:oauth:2.0:oob (Authorize)

let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!









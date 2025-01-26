//
//  PromptResponse.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation

struct DailyPromptResponse: Codable {
    let prompt: String
}

struct RandomPromptResponse: Codable {
    let random_prompt: String
}

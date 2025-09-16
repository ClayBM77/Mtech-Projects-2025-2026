import UIKit

func generateMadLib(pastVerb1: String, adjective1: String, place: String, adjective2: String, noun1: String, noun2: String, exclamation: String, pastVerb2: String, bodyPart: String, pluralNoun: String, adjective3: String, animal: String, clothing: String, food: String) -> String {
    
    var adjectives = [adjective1, adjective2, adjective3]
    var verbs = [pastVerb1, pastVerb2]
    var nouns = [noun1, noun2]
    
    adjectives.shuffle()
    verbs.shuffle()
    nouns.shuffle()
    
    let adjectiveShuffled1 = adjectives[0]
    let adjectiveShuffled2 = adjectives[1]
    let adjectiveShuffled3 = adjectives[2]
    
    let verbShuffled1 = verbs[0]
    let verbShuffled2 = verbs[1]
    
    let nounShuffled1 = nouns[0]
    let nounShuffled2 = nouns[1]
    
    let randomStorySelection = Int.random(in: 1...3)
    if pastVerb1 == "" || adjective1 == "" || place == "" || adjective2 == "" || noun1 == "" || noun2 == "" || exclamation == "" || pastVerb2 == "" || bodyPart == "" || pluralNoun == "" || adjective3 == "" || animal == "" || clothing == "" || food == "" {
        return "Invalid Input"
    } else {
        switch randomStorySelection {
        case 1:
            return "Yesterday, I \(verbShuffled1) into a \(adjectiveShuffled1) \(place) to find a \(adjectiveShuffled2) \(nounShuffled1) dancing on top of a \(nounShuffled2). It shouted, \"\(exclamation)!\" and then \(verbShuffled2) right into my \(bodyPart). I couldn't believe my \(pluralNoun)! Just when I thought things couldn’t get any \(adjectiveShuffled3), a \(animal) wearing a \(clothing) appeared and offered me a \(food)."
        case 2:
            return "Last night, I \(verbShuffled1) into a \(adjectiveShuffled1) \(place) during a dream, only to find a \(adjectiveShuffled2) \(nounShuffled1) floating above a giant \(nounShuffled2). It looked at me and yelled, \"\(exclamation)!\" before it \(verbShuffled2) into my \(bodyPart). Suddenly, my \(pluralNoun) turned into glitter. As things got even more \(adjectiveShuffled3), a \(animal) in a \(clothing) handed me a \(food) and vanished."
        case 3:
            return "This morning, I \(verbShuffled1) into a \(adjectiveShuffled1) \(place) for a job interview. A \(adjectiveShuffled2) \(nounShuffled1) greeted me by juggling a \(nounShuffled2) and yelling, \"\(exclamation)!\" I accidentally \(verbShuffled2) and hit my \(bodyPart) on a chair. My \(pluralNoun) scattered everywhere! To make things more \(adjectiveShuffled3), the boss turned out to be a \(animal) wearing a \(clothing) who offered me a \(food) and the job. Naturally, I said yes. "
        default:
            return "error"
        }
        
    }
}

print(generateMadLib(pastVerb1: "ran", adjective1: "funny", place: "Las Vegas", adjective2: "histerical", noun1: "Lebron James", noun2: "Moby Dick", exclamation: "Ker Chunk", pastVerb2: "Meandered", bodyPart: "jugular", pluralNoun: "cisterns", adjective3: "nefarious", animal: "pangolin", clothing: "scarf", food: "chimichanga"))

print(generateMadLib(pastVerb1: "scalping", adjective1: "silly", place: "Detroit", adjective2: "goofy", noun1: "Horror", noun2: "Astonishing", exclamation: "woah, you are very fun!!!", pastVerb2: "stabbing", bodyPart: "Lips", pluralNoun: "Astound", adjective3: "great", animal: "Human", clothing: "strings", food: "bread"))


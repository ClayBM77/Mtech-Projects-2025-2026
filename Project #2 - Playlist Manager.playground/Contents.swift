import UIKit
/*
 Your task is to build a playlist manager Playground. Using a Song struct and Playlist class, the core of your app will be an array of playlists. The Playlist class should include the following functions:
 
// Init
init()

// Core mutation
func add(_ song: Song) ✅
func remove(at index: Int) ✅
func clear() ✅

// Querying / reading
var count: Int { get } ✅
func allSongs() -> [Song] ✅
func totalDuration() -> Int ✅
func currentSong() -> Song? ✅

// Playback navigation
func play(at index: Int) -> Song? ✅
func playNext() -> Song? ✅
func playPrevious() -> Song? ✅

// Shuffle
func shuffle() ✅
 
 When "playing" a song, you can simply output it to the console. As implied by the playNext() and playPrevious() functions, you should also be keeping track of what song is currently playing.

 Black Diamond
 Add sorting features that allow users to reorder the playlist by duration, song name, artist name, and any other properties you'd like.
 Also allow for custom rearranging of the playlist with a function along the lines of func move(song: Song, to index: Int).
*/

struct Song: Equatable, CustomStringConvertible {
    var name = ""
    var artist = ""
    var duration: Int = 0
    
    var description: String {
        return "\(name) by \(artist), \(duration) seconds"
    }
}

let kneeDeep: Song = Song(name: "Knee Deep", artist: "Zac Brown Band", duration: 203)
let thankGodIDo: Song = Song(name: "Thank God I Do", artist: "Lauren Daigle", duration: 239)
let countOnMe: Song = Song(name: "Count on Me", artist: "Bruno Mars", duration: 179)
let happier: Song = Song(name: "Happier", artist: "Marshmello", duration: 214)
let goodLife: Song = Song(name: "Good Life", artist: "OneRepublic", duration: 261)
let riptide: Song = Song(name: "Riptide", artist: "Vance Joy", duration: 204)
let islandInTheSun: Song = Song(name: "Island in the Sun", artist: "Weezer", duration: 200)
let sundayBest: Song = Song(name: "Sunday Best", artist: "Surfaces", duration: 177)
let sunflower: Song = Song(name: "Sunflower", artist: "Post Malone & Swae Lee", duration: 158)
let feelItStill: Song = Song(name: "Feel It Still", artist: "Portugal. The Man", duration: 163)
let goodVibrations: Song = Song(name: "Good Vibrations", artist: "The Beach Boys", duration: 218)
let heySoulSister: Song = Song(name: "Hey, Soul Sister", artist: "Train", duration: 219)
let putItAllOnMe: Song = Song(name: "Put It All on Me", artist: "Ed Sheeran ft. Ella Mai", duration: 200)
let iLived: Song = Song(name: "I Lived", artist: "OneRepublic", duration: 220)
let upsideDown: Song = Song(name: "Upside Down", artist: "Jack Johnson", duration: 209)

class Playlist {
    var songList: [Song] = []
    var queue: [Song] = []
    var currentSong: Song
    init(songList: [Song], currentSong: Song) {
        self.songList = songList
        self.currentSong = currentSong
    }
    
    
    func add(_ song: Song) {
        songList.append(song)
    }
    
    func remove(_ song: Song) {
        if let index = songList.firstIndex(of: song) {
            songList.remove(at: index)
        }
    }
    func clear() {
        songList = []
    }
    var count: Int { return songList.count }
    func allSongs() -> [Song] {
        return songList
    }
    func totalDuration() -> Int {
        return songList.reduce(0) { $0 + $1.duration }
    }
    func songPlaying() -> Song? {
        return currentSong
    }
    func play(at index: Int) -> Song? {
        currentSong = songList[index]
        print(currentSong)
        return currentSong
    }
    func playNext() -> Song? {
        guard let currentIndex = songList.firstIndex(of: currentSong) else { return nil }
        let nextIndex = (currentIndex + 1) % songList.count
        currentSong = songList[nextIndex]
        print(currentSong)
        return currentSong
    }
    func playPrevious() -> Song? {
        guard let currentIndex = songList.firstIndex(of: currentSong) else { return nil }
        let previousIndex = songList[currentIndex - 1]
        currentSong = previousIndex
        print(currentSong)
        return currentSong
    }
    func shuffle() {
        songList.shuffle()
    }
}
    
var myList = Playlist(songList: [kneeDeep], currentSong: kneeDeep)

myList.add(thankGodIDo)
myList.add(upsideDown)
myList.playNext()
myList.playNext()
myList.playNext()
print(myList.allSongs())
print("\(myList.totalDuration()) seconds")

print(myList.allSongs())

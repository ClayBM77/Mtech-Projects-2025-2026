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
func playNext() -> Song?
func playPrevious() -> Song?

// Shuffle
func shuffle()
 
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
    var count: Int {return songList.count}
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
        return currentSong
    }
    func playNext() -> Song? {
        guard let currentIndex = songList.firstIndex(of: currentSong) else { return nil }
        let nextIndex = (currentIndex + 1) % songList.count
        currentSong = songList[nextIndex]
        return currentSong
    }
}
    
var myList = Playlist(songList: [kneeDeep], currentSong: kneeDeep)

myList.add(thankGodIDo)

print(myList.allSongs())
print(myList.totalDuration())

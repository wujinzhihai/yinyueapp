// D:\hongmengxitong\MusicApp\entry\src\main\ets\pages\MusicListPage.ets
import { router } from '@kit.ArkUI'
import { MusicApiService } from '../services/MusicApiService'
import { Song } from '../models/Song'
import { SongListItem } from '../components/SongListItem'

@Entry
@Component
struct MusicListPage {
  @State songList: Song[] = []

  aboutToAppear() {
    this.loadSongs()
  }

  private async loadSongs() {
    this.songList = await MusicApiService.getHotSongs()
  }

  private onSongClick(song: Song) {
    // ✅ 正确的 pushUrl 用法
    router.pushUrl({
      url: 'pages/PlayerPage',
      params: { songId: song.id }
    })
  }

  build() {
    Column() {
      Text('歌曲列表')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(16)

      List() {
        ForEach(this.songList, (song: Song) => {
          ListItem() {
            SongListItem({
              song: song,
              onItemClick: (clickedSong: Song) => {
                this.onSongClick(clickedSong)
              }
            })
          }
        }, (song: Song) => song.id.toString())
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}

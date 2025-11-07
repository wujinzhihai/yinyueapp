import { MusicApiService } from '../services/MusicApiService'
import { PlayerService } from '../services/PlayerService'
import { Song } from '../models/Song'
import { SongListItem } from '../components/SongListItem'
import { MiniPlayer } from '../components/MiniPlayer'

@Entry
@Component
struct Index {
  @State songList: Song[] = []
  @State searchKeyword: string = ''
  // ✅ 修复1：使用 getInstance() 获取单例
  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear() {
    // 加载歌曲列表
    this.loadSongs()
  }

  /**
   * 加载歌曲列表
   */
  private async loadSongs() {
    try {
      this.songList = await MusicApiService.getHotSongs()
      console.info('[Index] Loaded songs:', this.songList.length)

      // ✅ 添加弹窗提示（临时调试用）
      AlertDialog.show({
        title: '调试信息',
        message: `加载了 ${this.songList.length} 首歌曲`,
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
    } catch (error) {
      console.error('[Index] Load songs failed:', error)

      // ✅ 添加错误弹窗
      AlertDialog.show({
        title: '错误',
        message: `加载失败: ${error}`,
        confirm: {
          value: '确定',
          action: () => {}
        }
      })
    }
  }


  /**
   * 搜索歌曲
   */
  private async searchSongs() {
    if (this.searchKeyword.trim() === '') {
      await this.loadSongs()
    } else {
      try {
        this.songList = await MusicApiService.searchSongs(this.searchKeyword)
        console.info('[Index] Search results:', this.songList.length)
      } catch (error) {
        console.error('[Index] Search failed:', error)
      }
    }
  }

  /**
   * 点击歌曲项
   */
  private async onSongClick(song: Song) {
    console.info('[Index] Play song:', song.name)

    // ✅ 修复2：正确设置播放列表并播放
    // 1. 设置播放列表
    this.playerService.setPlaylist(this.songList)

    // 2. 播放指定歌曲
    const index = this.songList.indexOf(song)
    if (index >= 0) {
      await this.playerService.playSongAt(index)
    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('音乐播放器')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)

      // 搜索框
      Row() {
        Search({
          placeholder: '搜索歌曲、歌手',
          value: this.searchKeyword
        })
          .width('100%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .onChange((value: string) => {
            this.searchKeyword = value
          })
          .onSubmit(() => {
            this.searchSongs()
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(Color.White)

      // 歌曲列表
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
      .width('100%')  // ✅ 修复3：添加宽度
      .layoutWeight(1)
      .backgroundColor('#F8F8F8')
      .padding({ left: 8, right: 8, top: 8 })

      // 底部迷你播放器
      MiniPlayer()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8')
  }
}

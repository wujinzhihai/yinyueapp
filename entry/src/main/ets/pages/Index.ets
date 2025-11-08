// entry/src/main/ets/pages/Index.ets

import { Song } from '../models/Song'
import { MusicApiService } from '../services/MusicApiService'
import { PlayerService } from '../services/PlayerService'
import { SongListItem } from '../components/SongListItem'
import { MiniPlayer } from '../components/MiniPlayer'

@Entry
@Component
struct Index {
  @State songs: Song[] = []
  @State filteredSongs: Song[] = []
  @State searchText: string = ''
  @State isLoading: boolean = true
  @State isSearching: boolean = false  // ✅ 新增：搜索状态
  @State errorMessage: string = ''
  @State searchMode: boolean = false  // ✅ 新增：是否处于搜索模式

  private playerService: PlayerService = PlayerService.getInstance()
  @State playerStateVersion: number = 0
  private updateTimer: number = -1

  async aboutToAppear(): Promise<void> {
    console.info('[Index] ============ 页面启动 ============')
    await this.loadHotSongs()
    this.startPlayerStateUpdate()
  }

  aboutToDisappear(): void {
    clearInterval(this.updateTimer)
  }

  private startPlayerStateUpdate(): void {
    this.updateTimer = setInterval(() => {
      this.playerStateVersion++
    }, 500)
  }

  async loadHotSongs(): Promise<void> {
    this.isLoading = true
    this.errorMessage = ''
    this.searchMode = false  // ✅ 退出搜索模式

    try {
      console.info('[Index] 开始加载热门歌曲...')
      const songs = await MusicApiService.getHotSongs()

      this.songs = songs
      this.filteredSongs = songs
      this.playerService.setPlaylist(songs)

      console.info(`[Index] ✅ 加载成功: ${songs.length} 首歌曲`)
    } catch (err) {
      this.errorMessage = '加载失败,请检查网络连接'
      console.error('[Index] ❌ 加载失败:', JSON.stringify(err))
    } finally {
      this.isLoading = false
    }
  }

  // ✅ 新增：在线搜索方法
  async performOnlineSearch(keywords: string): Promise<void> {
    if (!keywords || keywords.trim() === '') {
      // 空字符串时恢复热门歌曲
      this.searchMode = false
      this.filteredSongs = this.songs
      return
    }

    this.isSearching = true
    this.searchMode = true
    console.info(`[Index] 🔍 开始在线搜索: "${keywords}"`)

    try {
      const results = await MusicApiService.searchSongs(keywords)
      this.filteredSongs = results
      console.info(`[Index] ✅ 搜索成功: ${results.length} 首歌曲`)

      if (results.length > 0) {
        // ✅ 更新播放列表为搜索结果
        this.playerService.setPlaylist(results)
      }
    } catch (err) {
      console.error('[Index] ❌ 搜索失败:', JSON.stringify(err))
      this.filteredSongs = []
    } finally {
      this.isSearching = false
    }
  }

  // ✅ 修改：搜索触发方法
  onSearchSubmit(): void {
    const keywords = this.searchText.trim()
    if (keywords === '') {
      // 清空搜索，恢复热门歌曲
      this.searchMode = false
      this.filteredSongs = this.songs
      console.info('[Index] 清空搜索，显示热门歌曲')
    } else {
      // 执行在线搜索
      this.performOnlineSearch(keywords)
    }
  }

  onSongClick(song: Song): void {
    const index = this.filteredSongs.findIndex(s => s.id === song.id)
    this.playerService.playSong(song, index)
    console.info(`[Index] 点击播放: ${song.name}`)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Text('🎵 音乐播放器')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 10 })

        Row() {
          TextInput({ placeholder: '搜索歌曲、歌手', text: this.searchText })
            .layoutWeight(1)
            .backgroundColor('#F5F5F5')
            .borderRadius(20)
            .padding({ left: 15, right: 15 })
            .onChange((value: string) => {
              this.searchText = value
            })
            .onSubmit(() => {
              this.onSearchSubmit()  // ✅ 回车触发在线搜索
            })

          Button('🔍')
            .fontSize(20)
            .backgroundColor('#FF1744')
            .fontColor('#FFFFFF')
            .width(50)
            .height(40)
            .margin({ left: 10 })
            .onClick(() => {
              this.onSearchSubmit()  // ✅ 按钮触发在线搜索
            })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 15 })

        // ✅ 新增：显示当前模式
        if (this.searchMode && !this.isSearching) {
          Row() {
            Text(`搜索 "${this.searchText}"`)
              .fontSize(14)
              .fontColor('#666666')
            Button('返回热门')
              .fontSize(12)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .margin({ left: 10 })
              .onClick(() => {
                this.searchText = ''
                this.loadHotSongs()
              })
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 10 })
        }

        if (this.isLoading || this.isSearching) {
          Column() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#FF1744')
            Text(this.isSearching ? '搜索中...' : '加载中...')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 10 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

        } else if (this.errorMessage) {
          Column() {
            Text('❌')
              .fontSize(40)
            Text(this.errorMessage)
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 10 })
            Button('重新加载')
              .fontSize(14)
              .margin({ top: 20 })
              .onClick(() => {
                this.loadHotSongs()
              })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

        } else if (this.filteredSongs.length === 0) {
          Column() {
            Text('🔍')
              .fontSize(40)
            Text(this.searchMode ? '没有找到相关歌曲' : '暂无歌曲')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 10 })
            if (this.searchMode) {
              Button('返回热门')
                .fontSize(14)
                .margin({ top: 20 })
                .onClick(() => {
                  this.searchText = ''
                  this.loadHotSongs()
                })
            }
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

        } else {
          List({ space: 8 }) {
            ForEach(this.filteredSongs, (song: Song) => {
              ListItem() {
                SongListItem({
                  song: song,
                  isPlaying: this.playerService.currentSong?.id === song.id && this.playerStateVersion >= 0,
                  onItemClick: (clickedSong: Song) => {
                    this.onSongClick(clickedSong)
                  }
                })
              }
            }, (song: Song) => song.id.toString())
          }
          .layoutWeight(1)
          .padding({ left: 15, right: 15, bottom: 100 })
          .scrollBar(BarState.Auto)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FAFAFA')

      if (this.playerService.currentSong && this.playerStateVersion >= 0) {
        MiniPlayer()
      }
    }
    .width('100%')
    .height('100%')
  }
}

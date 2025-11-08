// entry/src/main/ets/pages/Index.ets
import { Song } from '../models/Song'
import { MusicApiService } from '../services/MusicApiService'
import { PlayerService } from '../services/PlayerService'
import { SongListItem } from '../components/SongListItem'
import { MiniPlayer } from '../components/MiniPlayer'
import { BusinessError } from '@ohos.base'
import http from '@ohos.net.http'
import router from '@ohos.router'

// ✅ 接口定义（所有对象都是独立接口）
interface PlaylistData {
  tracks?: Song[]
}
interface TestResponse {
  code: number
  playlist?: PlaylistData
}
@Entry
@Component
struct Index {
  @State songs: Song[] = []
  @State filteredSongs: Song[] = []
  @State searchText: string = ''
  @State isLoading: boolean = true
  @State isSearching: boolean = false
  @State errorMessage: string = ''
  @State searchMode: boolean = false
  private playerService: PlayerService = PlayerService.getInstance()
  @State playerStateVersion: number = 0
  private updateTimer: number = -1
  // ✅ 网络测试方法（使用上面定义的接口）
  async testNetworkConnection(): Promise<void> {
    console.info('[TEST] ========== 开始网络测试 ==========')

    const testUrl = 'http://10.24.139.82:3000/playlist/detail?id=19723756'
    const httpRequest = http.createHttp()

    try {
      console.info(`[TEST] 🌐 测试URL: ${testUrl}`)

      const response = await httpRequest.request(testUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 10000,
        readTimeout: 10000
      })

      console.info(`[TEST] ✅ 状态码: ${response.responseCode}`)
      console.info(`[TEST] ✅ 响应类型: ${typeof response.result}`)
      console.info(`[TEST] ✅ 响应长度: ${(response.result as string).length}`)
      console.info(`[TEST] ✅ 响应前100字符: ${(response.result as string).substring(0, 100)}`)

      const data = JSON.parse(response.result as string) as TestResponse
      console.info(`[TEST] ✅ JSON解析成功`)
      console.info(`[TEST] ✅ code: ${data.code}`)
      console.info(`[TEST] ✅ 歌曲数量: ${data.playlist?.tracks?.length || 0}`)

    } catch (err) {
      console.error(`[TEST] ❌ 请求失败`)
      console.error(`[TEST] ❌ 错误类型: ${typeof err}`)
      console.error(`[TEST] ❌ 错误内容: ${JSON.stringify(err)}`)

      if (err && typeof err === 'object') {
        const error = err as BusinessError
        console.error(`[TEST] ❌ 错误码: ${error.code}`)
        console.error(`[TEST] ❌ 错误消息: ${error.message}`)
      }
    } finally {
      httpRequest.destroy()
    }
  }

  async aboutToAppear(): Promise<void> {
    console.info('[Index] ============ 页面启动 ============')

    // ✅ 先执行网络测试
    await this.testNetworkConnection()

    // 然后加载歌曲
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
    this.searchMode = false

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

  async performOnlineSearch(keywords: string): Promise<void> {
    if (!keywords || keywords.trim() === '') {
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
        this.playerService.setPlaylist(results)
      }
    } catch (err) {
      console.error('[Index] ❌ 搜索失败:', JSON.stringify(err))
      this.filteredSongs = []
    } finally {
      this.isSearching = false
    }
  }

  onSearchSubmit(): void {
    const keywords = this.searchText.trim()
    if (keywords === '') {
      this.searchMode = false
      this.filteredSongs = this.songs
      console.info('[Index] 清空搜索，显示热门歌曲')
    } else {
      this.performOnlineSearch(keywords)
    }
  }
  // ✅ 正确的 onSongClick 方法
  onSongClick(song: Song): void {
    const index = this.filteredSongs.findIndex(s => s.id === song.id)
    this.playerService.playSong(song, index)
    console.info(`[Index] 点击播放: ${song.name}`)

    // ✅ 路由跳转
    router.pushUrl({
      url: 'pages/PlayerPage'
    }).catch((err: Error) => {
      console.error('[Index] ❌ 路由跳转失败:', JSON.stringify(err))
    })
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
              this.onSearchSubmit()
            })

          Button('🔍')
            .fontSize(20)
            .backgroundColor('#FF1744')
            .fontColor('#FFFFFF')
            .width(50)
            .height(40)
            .margin({ left: 10 })
            .onClick(() => {
              this.onSearchSubmit()
            })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 15 })

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

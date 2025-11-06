import { SearchBar } from '../components/SearchBar'
import { SongListItem } from '../components/SongListItem'
import { MusicApiService } from '../services/MusicApiService'
import { Song } from '../models/Song'

/**
 * 搜索页面 - 支持热门推荐和搜索功能
 */
@Entry
@Component
struct SearchPage {
  @State songList: Song[] = []
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  @State isSearchMode: boolean = false

  /**
   * 页面加载时获取热门歌曲
   */
  async aboutToAppear(): Promise<void> {
    console.info('[SearchPage] 页面加载')
    await this.loadHotSongs()
  }

  /**
   * 加载热门歌曲
   */
  async loadHotSongs(): Promise<void> {
    this.isLoading = true
    this.errorMessage = ''
    this.isSearchMode = false

    try {
      console.info('[SearchPage] 开始加载热门歌曲')
      const songs: Song[] = await MusicApiService.getHotSongs(20)
      this.songList = songs
      console.info(`[SearchPage] 热门歌曲加载完成，共 ${songs.length} 首`)

      if (songs.length === 0) {
        this.errorMessage = '暂无推荐歌曲'
      }
    } catch (e) {
      let errorMsg: string = '加载失败'
      if (e instanceof Error) {
        errorMsg = e.message
      } else if (typeof e === 'string') {
        errorMsg = e
      } else if (e !== null && e !== undefined) {
        errorMsg = String(e)
      }

      console.error(`[SearchPage] 热门歌曲加载失败: ${errorMsg}`)
      this.errorMessage = '加载失败，请重试'
    } finally {
      this.isLoading = false
    }
  }

  /**
   * 执行搜索
   */
  async handleSearch(keyword: string): Promise<void> {
    // 清空搜索时恢复热门歌曲
    if (!keyword || keyword.trim() === '') {
      await this.loadHotSongs()
      return
    }

    this.isLoading = true
    this.errorMessage = ''
    this.songList = []
    this.isSearchMode = true

    try {
      console.info(`[SearchPage] 开始搜索: ${keyword}`)
      const songs: Song[] = await MusicApiService.searchSongs(keyword, 20)
      this.songList = songs
      console.info(`[SearchPage] 搜索完成，共 ${songs.length} 首歌曲`)

      if (songs.length === 0) {
        this.errorMessage = '未找到相关歌曲'
      }
    } catch (e) {
      let errorMsg: string = '未知错误'
      if (e instanceof Error) {
        errorMsg = e.message
      } else if (typeof e === 'string') {
        errorMsg = e
      } else if (e !== null && e !== undefined) {
        errorMsg = String(e)
      }

      console.error(`[SearchPage] 搜索失败: ${errorMsg}`)
      this.errorMessage = `搜索失败: ${errorMsg}`
    } finally {
      this.isLoading = false
    }
  }

  /**
   * 歌曲项点击事件
   */
  handleSongClick(song: Song): void {
    console.info(`[SearchPage] 点击歌曲: ${song.name}`)
    // TODO: 下阶段实现播放功能
  }

  build() {
    Column() {
      // 搜索栏
      SearchBar({
        onSearch: (keyword: string) => {
          this.handleSearch(keyword)
        }
      })

      // 标题栏（仅在推荐模式显示）
      if (!this.isSearchMode && !this.isLoading && this.songList.length > 0) {
        Row() {
          Text('🔥 热门推荐')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Center)
      }

      // 内容区域
      if (this.isLoading) {
        // 加载状态
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color('#1890FF')
          Text(this.isSearchMode ? '搜索中...' : '加载中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F5F5F5')
      } else if (this.errorMessage !== '') {
        // 错误状态
        Column() {
          Text('😕')
            .fontSize(48)
            .margin({ bottom: 12 })
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 20 })
          Button('重试')
            .fontSize(14)
            .backgroundColor('#1890FF')
            .borderRadius(4)
            .padding({ left: 24, right: 24, top: 8, bottom: 8 })
            .onClick(() => {
              if (this.isSearchMode) {
                this.loadHotSongs()
              } else {
                this.loadHotSongs()
              }
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F5F5F5')
      } else if (this.songList.length > 0) {
        // 结果列表（✅ 修复：添加宽高）
        List() {
          ForEach(this.songList, (song: Song) => {
            ListItem() {
              SongListItem({
                song: song,
                onItemClick: (clickedSong: Song) => {
                  this.handleSongClick(clickedSong)
                }
              })
            }
          }, (song: Song) => song.id.toString())
        }
        .width('100%')         // ✅ 明确指定宽度
        .height('100%')        // ✅ 明确指定高度
        .layoutWeight(1)
        .backgroundColor(Color.White)
        .divider({
          strokeWidth: 1,
          color: '#F0F0F0',
          startMargin: 16,
          endMargin: 16
        })
      } else {
        // 空状态
        Column() {
          Text('🎵')
            .fontSize(48)
            .margin({ bottom: 12 })
          Text('搜索你喜欢的歌曲')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

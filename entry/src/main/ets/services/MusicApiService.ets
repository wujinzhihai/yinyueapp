import { Song } from '../models/Song'

/**
 * 音乐API服务 - 当前使用模拟数据
 * TODO: 后续接入真实后端API
 */
export class MusicApiService {
  /**
   * 模拟热门歌曲数据
   */
  private static readonly MOCK_HOT_SONGS: Song[] = [
    new Song(
      1,
      '七里香',
      '周杰伦',
      '七里香',
      'https://via.placeholder.com/60x60/FF6B6B/FFFFFF?text=七里香'
    ),
    new Song(
      2,
      '稻香',
      '周杰伦',
      '魔杰座',
      'https://via.placeholder.com/60x60/4ECDC4/FFFFFF?text=稻香'
    ),
    new Song(
      3,
      '晴天',
      '周杰伦',
      '叶惠美',
      'https://via.placeholder.com/60x60/45B7D1/FFFFFF?text=晴天'
    ),
    new Song(
      4,
      '夜曲',
      '周杰伦',
      '十一月的萧邦',
      'https://via.placeholder.com/60x60/96CEB4/FFFFFF?text=夜曲'
    ),
    new Song(
      5,
      '告白气球',
      '周杰伦',
      '周杰伦的床边故事',
      'https://via.placeholder.com/60x60/FFEAA7/333333?text=告白气球'
    ),
    new Song(
      6,
      '等你下课',
      '周杰伦',
      '最伟大的作品',
      'https://via.placeholder.com/60x60/DFE6E9/333333?text=等你下课'
    ),
    new Song(
      7,
      '东风破',
      '周杰伦',
      '叶惠美',
      'https://via.placeholder.com/60x60/A8E6CF/333333?text=东风破'
    ),
    new Song(
      8,
      '菊花台',
      '周杰伦',
      '依然范特西',
      'https://via.placeholder.com/60x60/FFD3B6/333333?text=菊花台'
    ),
    new Song(
      9,
      '青花瓷',
      '周杰伦',
      '我很忙',
      'https://via.placeholder.com/60x60/FFAAA5/FFFFFF?text=青花瓷'
    ),
    new Song(
      10,
      '简单爱',
      '周杰伦',
      '范特西',
      'https://via.placeholder.com/60x60/FF8B94/FFFFFF?text=简单爱'
    ),
    new Song(
      11,
      '搁浅',
      '周杰伦',
      '七里香',
      'https://via.placeholder.com/60x60/C7CEEA/333333?text=搁浅'
    ),
    new Song(
      12,
      '以父之名',
      '周杰伦',
      '叶惠美',
      'https://via.placeholder.com/60x60/B5EAD7/333333?text=以父之名'
    )
  ]

  /**
   * 获取热门歌曲（模拟数据）
   * @param limit 返回数量
   * @returns 歌曲列表
   */
  static async getHotSongs(limit: number = 20): Promise<Song[]> {
    console.info(`[MusicApiService] 获取热门歌曲，数量: ${limit}`)

    // 模拟网络延迟
    return new Promise<Song[]>((resolve) => {
      setTimeout(() => {
        // ✅ 修复：使用 MusicApiService.MOCK_HOT_SONGS 而不是 this
        const songs: Song[] = MusicApiService.MOCK_HOT_SONGS.slice(
          0,
          Math.min(limit, MusicApiService.MOCK_HOT_SONGS.length)
        )
        console.info(`[MusicApiService] 返回 ${songs.length} 首热门歌曲`)
        resolve(songs)
      }, 500)
    })
  }

  /**
   * 搜索歌曲（模拟数据）
   * @param keyword 搜索关键词
   * @param limit 返回数量
   * @returns 歌曲列表
   */
  static async searchSongs(keyword: string, limit: number = 20): Promise<Song[]> {
    console.info(`[MusicApiService] 搜索歌曲，关键词: ${keyword}，数量: ${limit}`)

    // 模拟网络延迟
    return new Promise<Song[]>((resolve) => {
      setTimeout(() => {
        // ✅ 修复：使用 MusicApiService.MOCK_HOT_SONGS 而不是 this
        const results: Song[] = MusicApiService.MOCK_HOT_SONGS.filter((song: Song) =>
        song.name.toLowerCase().includes(keyword.toLowerCase()) ||
        song.artist.toLowerCase().includes(keyword.toLowerCase()) ||
        song.album.toLowerCase().includes(keyword.toLowerCase())
        ).slice(0, Math.min(limit, MusicApiService.MOCK_HOT_SONGS.length))

        console.info(`[MusicApiService] 搜索完成，找到 ${results.length} 首歌曲`)
        resolve(results)
      }, 800)
    })
  }
}

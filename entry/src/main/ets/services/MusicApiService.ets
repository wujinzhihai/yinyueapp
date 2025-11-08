// entry/src/main/ets/services/MusicApiService.ets

import { http } from '@kit.NetworkKit'
import { Song } from '../models/Song'

const BASE_URL = 'http://10.24.139.82'

// ✅ 使用 class 定义类型（ArkTS 要求）
class Artist {
  name: string = ''
}

class Album {
  name: string = ''
  picUrl: string = ''
}

class PlaylistTrack {
  id: number = 0
  name: string = ''
  ar: Artist[] = []
  al: Album = new Album()
  dt: number = 0
}

class Playlist {
  name: string = ''
  tracks: PlaylistTrack[] = []
}

class PlaylistResponse {
  code: number = 0
  playlist: Playlist = new Playlist()
}

class SearchSong {
  id: number = 0
  name: string = ''
  artists: Artist[] = []
  album: Album = new Album()
  duration: number = 0
}

class SearchResult {
  songs: SearchSong[] = []
}

class SearchResponse {
  code: number = 0
  result: SearchResult = new SearchResult()
}

export class MusicApiService {

  /**
   * 获取热门歌曲（使用歌单）
   */
  static async getHotSongs(): Promise<Song[]> {
    console.info('[MusicApiService] ========== 开始请求热门歌曲 ==========')

    const playlistId = '19723756'
    const url = `${BASE_URL}/playlist/detail?id=${playlistId}`
    console.info(`[MusicApiService] 请求 URL: ${url}`)

    try {
      const request = http.createHttp()

      const response = await request.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 10000,
        readTimeout: 10000,
        header: {
          'Content-Type': 'application/json'
        }
      })

      console.info(`[MusicApiService] 响应状态码: ${response.responseCode}`)

      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}`)
      }

      const resultStr: string = typeof response.result === 'string'
        ? response.result
        : JSON.stringify(response.result)

      const data: PlaylistResponse = JSON.parse(resultStr) as PlaylistResponse
      console.info(`[MusicApiService] JSON 解析成功`)

      if (!data.playlist?.tracks || !Array.isArray(data.playlist.tracks)) {
        console.error('[MusicApiService] ❌ 歌单数据格式错误')
        return []
      }

      const tracks: PlaylistTrack[] = data.playlist.tracks
      console.info(`[MusicApiService] 歌单歌曲数量: ${tracks.length}`)

      const songs: Song[] = tracks.slice(0, 50).map((item: PlaylistTrack) => {
        const id: number = item.id
        const name: string = item.name
        const artistName: string = (item.ar && item.ar.length > 0)
          ? item.ar[0].name
          : '未知歌手'
        const albumName: string = item.al?.name ?? '未知专辑'
        const duration: number = item.dt ?? 0
        const coverUrl: string = item.al?.picUrl ?? ''
        const audioUrl: string = `http://music.163.com/song/media/outer/url?id=${id}.mp3`

        return new Song(id, name, artistName, albumName, duration, audioUrl, coverUrl)
      })

      console.info(`[MusicApiService] ✅ 成功解析 ${songs.length} 首歌曲`)
      console.info('[MusicApiService] ========== 请求完成 ==========')

      request.destroy()
      return songs

    } catch (err) {
      console.error('[MusicApiService] ❌ 请求失败')
      console.error(`[MusicApiService] 错误: ${JSON.stringify(err)}`)
      return []
    }
  }

  /**
   * 搜索歌曲
   */
  static async searchSongs(keywords: string): Promise<Song[]> {
    console.info(`[MusicApiService] 搜索: ${keywords}`)

    const url = `${BASE_URL}/search?keywords=${encodeURIComponent(keywords)}`

    try {
      const request = http.createHttp()

      const response = await request.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 10000,
        readTimeout: 10000
      })

      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}`)
      }

      const resultStr: string = typeof response.result === 'string'
        ? response.result
        : JSON.stringify(response.result)

      const data: SearchResponse = JSON.parse(resultStr) as SearchResponse

      if (!data.result?.songs || !Array.isArray(data.result.songs)) {
        console.error('[MusicApiService] 搜索结果格式错误')
        return []
      }

      const songs: Song[] = data.result.songs.map((item: SearchSong) => {
        const id: number = item.id
        const name: string = item.name
        const artistName: string = (item.artists && item.artists.length > 0)
          ? item.artists[0].name
          : '未知歌手'
        const albumName: string = item.album?.name ?? '未知专辑'
        const duration: number = item.duration ?? 0
        const coverUrl: string = item.album?.picUrl ?? ''
        const audioUrl: string = `http://music.163.com/song/media/outer/url?id=${id}.mp3`

        return new Song(id, name, artistName, albumName, duration, audioUrl, coverUrl)
      })

      console.info(`[MusicApiService] 搜索到 ${songs.length} 首歌曲`)
      request.destroy()
      return songs

    } catch (err) {
      console.error('[MusicApiService] 搜索失败:', JSON.stringify(err))
      return []
    }
  }
}

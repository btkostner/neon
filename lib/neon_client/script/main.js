import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from 'topbar'

import 'alpinejs'
import 'phoenix_html'

import '../style/main.css'

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
const liveSocket = new LiveSocket('/live', Socket, {
  params: {
    _csrf_token: csrfToken
  }
})

topbar.config({ barColors: { 0: '#63b1bc' }, shadowBlur: 0 })
window.addEventListener('phx:page-loading-start', info => topbar.show())
window.addEventListener('phx:page-loading-stop', info => topbar.hide())

liveSocket.connect()

window.liveSocket = liveSocket
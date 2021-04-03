function draw (canvas) {
  const ctx = canvas.getContext('2d')

  canvas.width = canvas.offsetWidth
  canvas.height = canvas.offsetHeight

  const time = new Date()
  const squareSize = Math.max(canvas.width, canvas.height)
  const ringWidth = Math.min(Math.max(squareSize / 100, 3), 10)
  const ringSize = squareSize - (ringWidth * 7)

  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ctx.translate(canvas.width / 2, canvas.height / 2)

  ctx.rotate(((2 * Math.PI) / 60) * time.getSeconds() + ((2 * Math.PI) / 60000) * time.getMilliseconds())

  ctx.beginPath()
  ctx.arc(ringWidth, 0, ringSize / 2, 0, Math.PI * 2, false)
  ctx.fillStyle = 'rgba(6, 182, 212, 1)'
  ctx.strokeStyle = null
  ctx.lineWidth = 0
  ctx.shadowBlur = ringWidth * 2
  ctx.shadowColor = 'rgba(6, 182, 212, 1)'
  ctx.fill()
  ctx.closePath()

  ctx.rotate(((2 * Math.PI) / 60) * time.getSeconds() + ((2 * Math.PI) / 60000) * time.getMilliseconds())
  ctx.rotate(((2 * Math.PI) / 60) * time.getSeconds() + ((2 * Math.PI) / 60000) * time.getMilliseconds())

  ctx.beginPath()
  ctx.arc(ringWidth * 1.1, 0, ringSize / 1.975, 0, Math.PI * 2, false)
  ctx.fillStyle = 'rgba(6, 182, 212, 1)'
  ctx.strokeStyle = null
  ctx.lineWidth = 0
  ctx.shadowBlur = ringWidth * 2
  ctx.shadowColor = 'rgba(6, 182, 212, 1)'
  ctx.fill()
  ctx.closePath()

  ctx.rotate(((2 * Math.PI) / 60) * time.getSeconds() + ((2 * Math.PI) / 60000) * time.getMilliseconds())

  ctx.beginPath()
  ctx.arc(ringWidth * 2, 0, ringSize / 2.4, 0, Math.PI * 2, false)
  ctx.fillStyle = 'rgba(6, 182, 212, 1)'
  ctx.strokeStyle = null
  ctx.lineWidth = 0
  ctx.shadowBlur = ringWidth * 2
  ctx.shadowColor = 'rgba(6, 182, 212, 1)'
  ctx.fill()
  ctx.closePath()

  ctx.globalCompositeOperation = 'destination-out'

  ctx.beginPath()
  ctx.arc(0, 0, ringSize / 2, 0, Math.PI * 2, false)
  ctx.fillStyle = 'white'
  ctx.strokeStyle = null
  ctx.lineWidth = 0
  ctx.shadowBlur = 0
  ctx.shadowColor = null
  ctx.fill()

  ctx.globalCompositeOperation = 'source-over'

  ctx.beginPath()
  ctx.arc(0, 0, ringSize / 2, 0, Math.PI * 2, false)
  ctx.fillStyle = null
  ctx.strokeStyle = 'rgba(6, 182, 212, 1)'
  ctx.lineWidth = ringWidth
  ctx.shadowBlur = ringWidth * 3
  ctx.shadowColor = 'rgba(6, 182, 212, 0.5)'
  ctx.stroke()
  ctx.closePath()

  ctx.beginPath()
  ctx.arc(0, 0, ringSize / 2, 0, Math.PI * 2, false)
  ctx.fillStyle = null
  ctx.strokeStyle = 'rgba(6, 182, 212, 1)'
  ctx.lineWidth = ringWidth
  ctx.shadowBlur = ringWidth * 3
  ctx.shadowColor = 'rgba(6, 182, 212, 0.5)'
  ctx.stroke()
  ctx.closePath()

  window.requestAnimationFrame(() => draw(canvas))
}

function init () {
  document.querySelectorAll('canvas.neon-logo').forEach(draw)
}

if (document.readyState === 'complete') {
  init()
} else {
  document.addEventListener('DOMContentLoaded', init)
}

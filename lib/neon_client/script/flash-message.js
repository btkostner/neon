export const FlashMessageComponent = () => ({
  visible: false,

  _close () {
    const evt = new Event('flash-message-close')
    this.$el.dispatchEvent(evt)
  },

  close () {
    if (this.visible) {
      this.visible = false
      setTimeout(() => this._close(), 350)
    }
  },

  open () {
    this.visible = true

    const timeout = this.$el.dataset.flashMessageTimeout
    if (timeout) {
      setTimeout(() => this.close(), timeout)
    }
  },

  messageEl: {
    'x-show' () {
      return this.visible
    },

    'x-transition:enter' () {
      return 'transform ease-out duration-300 transition'
    },

    'x-transition:enter-start' () {
      return 'translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2'
    },

    'x-transition:enter-end' () {
      return 'translate-y-0 opacity-100 sm:translate-x-0'
    },

    'x-transition:leave' () {
      return 'transition ease-in duration-100'
    },

    'x-transition:leave-start' () {
      return 'opacity-100'
    },

    'x-transition:leave-end' () {
      return 'opacity-0'
    }
  }
})

export const FlashMessageHook = {
  mounted () {
    const flashMessageId = this.el.dataset.flashMessageId

    this.el.addEventListener('flash-message-close', () => {
      this.pushEvent('lv:clear-flash', { key: flashMessageId })
    })
  }
}

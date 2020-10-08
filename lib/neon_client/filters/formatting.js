const form = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD'
})

export function currency (amount) {
  return form.format(amount)
}

export function round (value, decimals = 2) {
  return Number(value).toFixed(decimals)
}

export function percentage (value) {
  return `${round(value, 2)}%`
}

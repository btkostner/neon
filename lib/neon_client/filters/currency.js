const form = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD'
})

export default function (amount) {
  return form.format(amount)
}

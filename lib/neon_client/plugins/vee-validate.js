import { extend, setInteractionMode } from 'vee-validate'
import * as rules from 'vee-validate/dist/rules'

setInteractionMode('eager')

Object.keys(rules).forEach((rule) => {
  // eslint-disable-next-line import/namespace
  extend(rule, rules[rule])
})

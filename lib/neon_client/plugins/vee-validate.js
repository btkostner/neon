import { extend, setInteractionMode } from 'vee-validate'
// eslint-disable-next-line import/namespace
import * as rules from 'vee-validate/dist/rules'

setInteractionMode('eager')

Object.keys(rules).forEach((rule) => {
  extend(rule, rules[rule])
})

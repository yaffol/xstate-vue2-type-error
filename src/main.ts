import Vue from 'vue'
import App from './App.vue'
import './registerServiceWorker'
import { inspect } from '@xstate/inspect'
import VueCompositionAPI from '@vue/composition-api'

Vue.use(VueCompositionAPI)

inspect({ iframe: false })

Vue.config.productionTip = false

new Vue({
  render: h => h(App)
}).$mount('#app')

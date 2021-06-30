import Vue from 'vue'
import Vuetify from 'vuetify/lib/framework'

Vue.use(Vuetify)

export default new Vuetify({
  theme: {
    themes: {
      light: {
        primary: '#3eb1c8',
        secondary: '#4f5858',
        accent: '#3eb1c8',
        error: '#ef3340',
        info: '#2972fa',
        success: '#00ab84',
        warning: '#ffc72c'
      }
    }
  }
})

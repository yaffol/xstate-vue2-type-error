<template>
  <div>
    <h1>Provide/inject actors in xstate with Vue's composition API</h1>
    <some-component />
  </div>
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'
import SomeComponent from './SomeComponent.vue'
import { provideToggleService } from './toggle.machine'

export default defineComponent({
  components: { SomeComponent },
  setup () {
    provideToggleService()
  }
})
</script>

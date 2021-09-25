<template>
  <div>
  <button @click="send('TOGGLE')">
    Click me ({{ state.matches("active") ? "✅" : "❌" }})
  </button>
  <code>
    Toggled
    <strong>{{ state.context.count }}</strong> times
  </code>
    <input v-model="text">
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch } from '@vue/composition-api'
import { useToggleService } from './toggle.machine'

export default defineComponent({
  setup () {
    const { state, send } = useToggleService()
    const text = ref('')
    watch(text, (currentValue, oldValue) => {
      send('TOGGLE')
    })
    return {
      state,
      send,
      text
    }
  }
})
</script>

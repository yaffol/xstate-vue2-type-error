import { inject, InjectionKey, provide } from '@vue/composition-api'
import { useActor, useInterpret } from 'xstate-vue2'
import { createMachine, assign, InterpreterFrom } from 'xstate'

type ToggleEvent =
  | { type: 'TOGGLE' }
  | { type: 'SOME_EVENT' };

const toggleMachine = createMachine<{ count: number }, ToggleEvent>({
  id: 'toggle',
  initial: 'inactive',
  context: {
    count: 0
  },
  states: {
    inactive: {
      on: { TOGGLE: 'active' }
    },
    active: {
      entry: assign({ count: (ctx) => ctx.count + 1 }),
      on: { TOGGLE: 'inactive' }
    }
  }
})

export type ToggleService = InterpreterFrom<typeof toggleMachine>;
const toggleServiceSymbol: InjectionKey<ToggleService> = Symbol('toggleServiceSymbol')

export function provideToggleService () {
  const service = useInterpret(toggleMachine, { devTools: true })
  provide(toggleServiceSymbol, service)
}

export function useToggleService () {
  const service = inject(toggleServiceSymbol)

  if (!service) {
    throw new Error('Toggle service not provided.')
  }

  return useActor(service)
}

<template>
  <div>
    <group gutter='0'>
      <x-number align="left" :value="0" :min="-2" :max="2" fillable></x-number>
    </group>
  </div>
</template>

<script>
  import { GroupTitle, Group, XNumber} from 'vux'
    export default {
        components: {
          GroupTitle,
          Group,
          XNumber
        },
        methods: {

        },
        data(){
            return {

            }
        }
    }
</script>

<style lang="less" scoped>

</style>

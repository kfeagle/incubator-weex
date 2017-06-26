<template>
  <div @viewappear="viewappear" @viewdisappear="viewdisappear">
    <text style="font-size: 100px;">Hello World.</text>
  </div>
</template>

<script>

  var modal = weex.requireModule('modal')
  module.exports = {
    methods: {
      viewappear: function () {
        modal.toast({
          'message': 'appear',
          'duration': 2
        })
      },
      viewdisappear: function () {
        modal.toast({
          'message': 'disappear',
          'duration': 2
        })
      },
    }
  }
</script>